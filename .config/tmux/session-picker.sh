#!/usr/bin/env bash
set -euo pipefail

current=$(tmux display-message -p '#S')

selected=$(tmux list-sessions -F '#{session_name}' \
  | fzf --ansi \
        --prompt='session> ' \
        --header='enter=switch  ctrl-/=toggle preview' \
        --preview='tmux capture-pane -ep -t {} 2>/dev/null' \
        --preview-window='right:60%' \
        --bind='ctrl-/:toggle-preview' \
        --query="" || true)

if [ -n "$selected" ] && [ "$selected" != "$current" ]; then
  tmux switch-client -t "$selected"
fi
