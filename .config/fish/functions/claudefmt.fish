function claudefmt --description 'Format a Claude Code transcript as Markdown and open in nvim (new tmux window)'
    set -l proj_root "$HOME/.claude/projects"
    set -l file

    if test (count $argv) -ge 1; and test -f "$argv[1]"
        # explicit path
        set file "$argv[1]"
    else if test (count $argv) -ge 1
        # session id or prefix — search across all projects
        set file (find "$proj_root" -type f -name "$argv[1]*.jsonl" 2>/dev/null | head -n1)
    else
        # no arg: newest transcript for the current project dir
        set -l pdir "$proj_root/"(pwd | string replace -a / - | string replace -a . -)
        test -d "$pdir"; and set file (ls -t "$pdir"/*.jsonl 2>/dev/null | head -n1)
        test -z "$file"; and set file (ls -t "$proj_root"/*/*.jsonl 2>/dev/null | head -n1)
    end

    if test -z "$file"; or not test -f "$file"
        echo "claudefmt: no transcript found"(test (count $argv) -ge 1; and echo " for '$argv[1]'") >&2
        return 1
    end

    set -l jqprog '
      select(.type=="user" or .type=="assistant")
      | (.message.role // .type) as $role
      | (.timestamp // "") as $t
      | (if $role=="user" then "## 🧑 User" else "## 🤖 Assistant" end)
        + (if $t != "" then "  `" + $t + "`" else "" end)
        + "\n\n"
        + ( .message.content
            | if type == "string" then .
              else ( map(
                  if .type=="text" then .text
                  elif .type=="thinking" then "💭 *thinking:* " + (.thinking // "")
                  elif .type=="tool_use" then "🔧 **tool → " + (.name // "") + "**\n```json\n" + (.input | tojson) + "\n```"
                  elif .type=="tool_result" then
                    ( .content | if type=="array" then (map(.text // "") | join("\n")) else tostring end ) as $c
                    | "📤 **tool result**\n```\n" + (if ($c|length) > 2000 then $c[0:2000] + "\n… (truncated)" else $c end) + "\n```"
                  else empty end
                ) | join("\n\n") )
              end )
        + "\n\n---"
    '

    set -l out (mktemp -t claudefmt.XXXXXX).md
    begin
        echo "# Transcript: $file"
        echo
        jq -r "$jqprog" <"$file"
    end >"$out"

    if set -q TMUX
        tmux new-window -n claudefmt "nvim '$out'"
    else
        nvim "$out"
    end
end
