#!/usr/bin/env bash
set -euo pipefail

current=$(tmux display-message -p '#S')

selected=$(tmux list-sessions -F '#{session_name}' \
  | fzf --ansi \
        --no-input \
        --no-info \
        --prompt='search> ' \
        --header='j/k=move  g/G=top/bottom  enter=switch  /=search  esc=quit' \
        --preview='tmux capture-pane -ep -t {} 2>/dev/null' \
        --preview-window='right:60%' \
        --bind='j:down,k:up,g:first,G:last' \
        --bind='/:show-input+unbind(j,k,g,G)' \
        --bind='ctrl-/:toggle-preview' \
        --query="" || true)

if [ -n "$selected" ] && [ "$selected" != "$current" ]; then
  tmux switch-client -t "$selected"
fi
