#!/usr/bin/env bash
set -euo pipefail

current=$(tmux display-message -p '#S')

selected=$(tmux list-sessions -F '#{session_name}' \
  | fzf -m \
        --prompt='kill> ' \
        --header='tab=multi-select  enter=kill  ctrl-/=toggle preview' \
        --preview='tmux capture-pane -ep -t {} 2>/dev/null' \
        --preview-window='right:60%' \
        --bind='ctrl-/:toggle-preview' || true)

[ -z "$selected" ] && exit 0

while IFS= read -r s; do
  [ -z "$s" ] && continue
  tmux kill-session -t "$s"
done <<< "$selected"
