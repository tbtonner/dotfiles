function nvim
    if test (count $argv) -eq 0
        _nvim_run_fzf files (fd --hidden --type f .)
        return
    end

    if test (count $argv) -ne 1; or string match -q -- '-*' $argv[1]; or test -d $argv[1]
        command nvim $argv
        return
    end

    set -l parsed (_nvim_parse_arg $argv[1])
    set -l file $parsed[1]
    set -l line $parsed[2]

    if test -f $file
        _nvim_open $file $line
        return
    end

    # Arg has a `/` — treat as a path the user wants to open or create, not a search term.
    if string match -q '*/*' -- $file
        _nvim_open $file $line
        return
    end

    set -l rg_out (rg --hidden --line-number --with-filename --no-heading --color=never --smart-case --fixed-strings -- "$file" 2>/dev/null)
    switch (count $rg_out)
        case 1
            set -l parts (string split -m2 ':' $rg_out[1])
            _nvim_open $parts[1] $parts[2]
            return
        case 0
            # Fall through to fd.
        case '*'
            _nvim_run_fzf rg $rg_out
            return
    end

    set -l fd_out (fd --hidden --type f "$file" 2>/dev/null)
    switch (count $fd_out)
        case 0
            _nvim_open $file $line
        case 1
            _nvim_open $fd_out[1] ""
        case '*'
            _nvim_run_fzf files $fd_out
    end
end

# Open a file, optionally jumping to a line.
function _nvim_open
    set -l file $argv[1]
    set -l line $argv[2]
    set -l args
    test -n "$line"; and set args +"$line"
    command nvim $args "$file"
end

# Parse an arg into "<file>\n<line>". Recognises GitHub blob URLs, `path#L42`,
# range `:42-50` (start), `:42`, or a bare token.
function _nvim_parse_arg
    set -l arg $argv[1]

    if string match -qr '^(https?://)?github\.com/' -- $arg
        set -l line ""
        string match -qr '#L\d+' -- $arg; and set line (string replace -r '^.*#L(\d+).*$' '$1' $arg)
        set -l url_path (string replace -r '#.*$' '' $arg)
        set -l file (string replace -r '^(https?://)?github\.com/[^/]+/[^/]+/blob/[^/]+/' '' $url_path)
        set -l repo_root (git rev-parse --show-toplevel 2>/dev/null)
        test -n "$repo_root"; and set file "$repo_root/$file"
        echo $file
        echo $line
        return
    end

    if string match -qr '^.+#L\d+' -- $arg
        set -l parts (string split -m1 '#' $arg)
        echo $parts[1]
        echo (string replace -r '^L(\d+).*' '$1' $parts[2])
        return
    end

    if string match -qr '^.+:\d+-\d+$' -- $arg
        set -l parts (string split -r -m1 ':' $arg)
        echo $parts[1]
        echo (string replace -r '^(\d+)-\d+$' '$1' $parts[2])
        return
    end

    if string match -qr '^.+:\d+$' -- $arg
        set -l parts (string split -r -m1 ':' $arg)
        echo $parts[1]
        echo $parts[2]
        return
    end

    echo $arg
    echo ""
end

# Format one `:vsplit` / `:split` ex-command segment.
function _nvim_split_segment
    set -l split $argv[1]
    set -l file $argv[2]
    set -l line $argv[3]
    set -l lp
    test -n "$line"; and set lp "+$line "
    echo "$split $lp$file"
end

# Trim rg `file:line:content` matches down to `file:line` for fzf display.
function _nvim_format_rg_for_fzf
    for match in $argv
        set -l p (string split -m2 ':' $match)
        printf '%s:%s\n' $p[1] $p[2]
    end
end

# Open fzf picks. $argv[1] is the expect-key (or ""), $argv[2..] are selections.
function _nvim_open_selections
    set -l key $argv[1]
    set -l sels $argv[2..]
    test (count $sels) -eq 0; and return

    set -l files
    set -l lnums
    for sel in $sels
        set -l parsed (_nvim_parse_arg $sel)
        set -a files $parsed[1]
        set -a lnums $parsed[2]
    end

    set -l prefix
    test -n "$lnums[1]"; and set prefix +"$lnums[1]"

    switch $key
        case ctrl-v ctrl-x
            set -l split vsplit
            test "$key" = ctrl-x; and set split split
            set -l args $prefix "$files[1]"
            for i in (seq 2 (count $files))
                set -a args -c (_nvim_split_segment $split $files[$i] $lnums[$i])
            end
            command nvim $args
        case '*'
            command nvim $prefix $files
    end
end

# Run fzf over $argv[2..] in `rg` or `files` mode, then open picks.
function _nvim_run_fzf
    set -l mode $argv[1]
    set -l items $argv[2..]

    set -l result
    switch $mode
        case rg
            set -l preview 'bat --color=always --highlight-line {2} --style=numbers,changes {1} 2>/dev/null || cat {1}'
            set result (_nvim_format_rg_for_fzf $items | _fzf_pick \
                -m +i --delimiter=: \
                "--preview=$preview" \
                "--preview-window=right:60%:+{2}-5" \
                --bind=ctrl-/:toggle-preview \
                --expect=ctrl-v,ctrl-x)
        case '*'
            set -l preview 'bat --color=always --style=numbers,changes {} 2>/dev/null || cat {}'
            set result (printf '%s\n' $items | _fzf_pick \
                -m +i \
                "--preview=$preview" \
                "--preview-window=right:60%" \
                --bind=ctrl-/:toggle-preview \
                --expect=ctrl-v,ctrl-x)
    end

    test (count $result) -eq 0; and return
    _nvim_open_selections $result[1] $result[2..]
end
