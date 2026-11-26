#!/bin/sh
# PostToolUse hook: check lines Claude added to a Go file against the mechanical Code style rules in
# ~/.claude/CLAUDE.md. Only lines changed since HEAD are checked, so committed code stays the baseline.
# Exit 2 feeds the findings back to Claude. POSIX sh and awk only, so it behaves the same on macOS and Arch.

file=$(jq -r '.tool_input.file_path // empty')

case "$file" in
  *.go) ;;
  *) exit 0 ;;
esac
case "$file" in
  *.generated.go | *v4.gen.go | */generated/* | */mocks/*) exit 0 ;;
esac
[ -f "$file" ] || exit 0

dir=$(dirname "$file")
base=$(basename "$file")

# Prints the added line numbers, or "all" when the whole file is new to git.
added_lines() {
  if ! git -C "$dir" rev-parse --verify -q HEAD >/dev/null 2>&1; then
    echo all
    return
  fi
  if ! git -C "$dir" ls-files --error-unmatch "$base" >/dev/null 2>&1; then
    echo all
    return
  fi
  git -C "$dir" diff -U0 HEAD -- "$base" | awk '
    /^@@/ {
      split($3, a, ",")
      start = substr(a[1], 2)
      count = (2 in a) ? a[2] : 1
      for (i = 0; i < count; i++) print start + i
    }'
}

lines=$(added_lines)
[ -n "$lines" ] || exit 0

is_test=0
case "$file" in
  *_test.go) is_test=1 ;;
esac

findings=$(echo "$lines" | awk -v file="$file" -v is_test="$is_test" '
  FNR == NR {
    if ($0 == "all") all = 1
    added[$0] = 1
    next
  }

  function report(rule) {
    printf "%s:%d: %s\n    %s\n", file, FNR, rule, $0
  }

  function is_added(n) {
    return all || (n in added)
  }

  {
    line = $0
    is_comment = line ~ /^[[:space:]]*\/\//

    if (is_test && line ~ /^func[[:space:]]/ && prev ~ /^\/\// && (is_added(FNR) || is_added(FNR - 1)))
      report("doc comment on a test function or helper")
    prev = line

    if (!is_added(FNR) || is_comment) next

    if (line ~ /}[[:space:]]*else([^[:alnum:]_]|$)/)
      report("no else: pull the branch into a helper with early returns")

    if (line ~ /^[[:space:]]*return[[:space:]](.*[^[:alnum:]_.])?err[[:space:]]*$/)
      report("bare return of err: wrap it with fmt.Errorf(\"...: %w\", err) unless it is a sentinel/typed error")

    if (line ~ /for[[:space:]]+[[:alnum:]_]+[[:space:]]*:=[[:space:]]*0[[:space:]]*;[^;]*<[^;]*;[[:space:]]*[[:alnum:]_]+\+\+/)
      report("C-style loop: use for i := range n")

    if (line ~ /\([[:space:]]*[^()[:space:]][^()]*,[[:space:]]*$/)
      report("wrapped call/signature: break after the opening parenthesis, one argument per line")

    if (line !~ /:=|[^=!<>]=[^=]/) {
      shared = "[[:alnum:]_]+,[[:space:]]+[[:alnum:]_]+[[:space:]]+[*[:alpha:].[]"
      if ((line ~ /func/ && line ~ ("[(,][[:space:]]*" shared)) || line ~ ("^[[:space:]]+" shared ".*,[[:space:]]*$"))
        report("shared parameter type: give every parameter its own type")
    }
  }
' - "$file")

[ -n "$findings" ] || exit 0

{
  echo "Code style check (~/.claude/CLAUDE.md) flagged lines you just wrote. Fix them now, unless a rule's stated exception applies:"
  echo "$findings"
} >&2
exit 2
