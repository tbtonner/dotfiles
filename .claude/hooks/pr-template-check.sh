#!/usr/bin/env bash
# PostToolUse/Bash hook: after `gh pr create|edit` or `gh stack submit|sync`, check each open couchbase-cloud PR it
# touched against the PR rules in ~/.claude/CLAUDE.md and the repo AGENTS.md: no Template Selection section, an
# uncommented Self Review section with its box between Pull Request Category and Testing Approach, and draft on create.
# The core@couchbase-claude plugin already checks the Description section, so this skips it. Runs after the command,
# so it reads the body GitHub stored; decision "block" feeds the problems back to Claude to fix with gh pr edit.
# Plain bash, grep -E and awk only, so it behaves the same on macOS and Arch.
set -uo pipefail

input=$(cat)
command=$(printf '%s' "$input" | jq -r '.tool_input.command // ""')
cwd=$(printf '%s' "$input" | jq -r '.cwd // ""')

pr_cmd='(^|[^[:alnum:]_-])gh[[:space:]]+pr[[:space:]]+(create|edit)'
stack_cmd='(^|[^[:alnum:]_-])gh[[:space:]]+stack[[:space:]]+(submit|sync)'
create_cmd='(^|[^[:alnum:]_-])gh[[:space:]]+(pr[[:space:]]+create|stack[[:space:]]+submit)'

[[ $command =~ $pr_cmd || $command =~ $stack_cmd ]] || exit 0
[[ -n $cwd && -d $cwd ]] && cd "$cwd"

url_re='https://github\.com/couchbasecloud/couchbase-cloud/pull/[0-9]+'

# Prints the couchbase-cloud PR URLs from the command output, plus the whole stack's for gh stack commands. Falls back
# to the current branch's PR when a gh pr command printed none (output redirected or quiet).
pr_urls() {
  local printed

  printed=$(printf '%s' "$input" | jq -r '(.tool_response.stdout // ""), (.tool_response.stderr // "")' | grep -Eo "$url_re")
  printf '%s\n' "$printed"
  if [[ $command =~ $stack_cmd ]]; then
    gh stack view --json 2>/dev/null | grep -Eo "$url_re"
    return
  fi
  [[ -z $printed ]] && gh pr view --json url --jq .url 2>/dev/null | grep -Eo "$url_re"
}

# Prints the body with HTML comments removed, including multi-line ones.
strip_comments() {
  awk '
    {
      line = $0
      out = ""
      while (line != "") {
        if (in_comment) {
          end = index(line, "-->")
          if (end == 0) { line = ""; continue }
          line = substr(line, end + 3)
          in_comment = 0
          continue
        }
        start = index(line, "<!--")
        if (start == 0) { out = out line; line = ""; continue }
        out = out substr(line, 1, start - 1)
        line = substr(line, start + 4)
        in_comment = 1
      }
      print out
    }
  '
}

# Prints the line number of the first "## <name>" heading, or nothing.
heading_line() {
  local body=$1
  local name=$2

  printf '%s\n' "$body" | grep -nE "^##[[:space:]]+${name}[[:space:]]*$" | head -1 | cut -d: -f1
}

# Prints a "; "-separated list of Self Review problems, or nothing.
self_review_problems() {
  local body=$1
  local review category testing

  review=$(heading_line "$body" 'Self Review')
  category=$(heading_line "$body" 'Pull Request Category')
  testing=$(heading_line "$body" 'Testing Approach')

  if [[ -z $review ]]; then
    printf '%s' 'the "## Self Review" section is missing or still commented out; '
    return
  fi
  if [[ -n $category && $review -lt $category ]] || [[ -n $testing && $review -gt $testing ]]; then
    printf '%s' '"## Self Review" is not between "## Pull Request Category" and "## Testing Approach"; '
  fi
  if ! printf '%s\n' "$body" | grep -Eq '^- \[[ xX]\] I have self-reviewed this PR[[:space:]]*$'; then
    printf '%s' 'the "- [ ] I have self-reviewed this PR" box is missing from "## Self Review"; '
  fi
}

# Prints a "; "-separated list of problems with one PR, or nothing.
pr_problems() {
  local url=$1
  local view body

  view=$(gh pr view "$url" --json body,isDraft,state 2>/dev/null) || return
  [[ $(printf '%s' "$view" | jq -r .state) == OPEN ]] || return

  body=$(printf '%s' "$view" | jq -r .body | tr -d '\r' | strip_comments)

  if [[ -n $(heading_line "$body" 'Template Selection') ]]; then
    printf '%s' 'it has a "## Template Selection" section (drop it entirely); '
  fi
  self_review_problems "$body"
  if [[ $command =~ $create_cmd && $(printf '%s' "$view" | jq -r .isDraft) == false ]]; then
    printf '%s' 'it is not a draft (run gh pr ready --undo unless the user asked for a ready PR); '
  fi
}

report=""
while read -r url; do
  [[ -n $url ]] || continue
  problems=$(pr_problems "$url")
  [[ -n $problems ]] && report+="${url}: ${problems%; }. "
done < <(pr_urls | sort -u)

[[ -n $report ]] || exit 0

jq -n --arg report "$report" '{
  decision: "block",
  reason: ("PR description rules broken. " + $report + "Fetch each live body with gh pr view --json body, fix only these problems, keep every other section as it is, and update with gh pr edit --body-file. Never tick the Self Review box.")
}'
