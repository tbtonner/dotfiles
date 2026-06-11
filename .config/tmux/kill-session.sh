#!/usr/bin/env bash
set -euo pipefail

current=$(tmux display-message -p '#S')

selected=$(tmux list-sessions -F '#{session_name}' \
  | fzf -m \
        --no-input \
        --no-info \
        --prompt='search> ' \
        --header='j/k=move  tab=multi-select  enter=kill  /=search  esc=quit' \
        --preview='tmux capture-pane -ep -t {} 2>/dev/null' \
        --preview-window='right:60%' \
        --bind='j:down,k:up,g:first,G:last' \
        --bind='/:show-input+unbind(j,k,g,G)' \
        --bind='ctrl-/:toggle-preview' || true)

[ -z "$selected" ] && exit 0

while IFS= read -r s; do
  [ -z "$s" ] && continue
  tmux kill-session -t "$s"
done <<< "$selected"
