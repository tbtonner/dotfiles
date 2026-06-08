#!/usr/bin/env bash
set -euo pipefail

selected=$(tmux list-windows -a -F '#{session_name}:#{window_index}	#{session_name} · #{window_name}' \
  | fzf --ansi \
        --delimiter='	' \
        --with-nth=2 \
        --prompt='window> ' \
        --header='enter=switch  ctrl-/=toggle preview' \
        --preview='tmux capture-pane -ep -t {1} 2>/dev/null' \
        --preview-window='right:60%' \
        --bind='ctrl-/:toggle-preview' || true)

if [ -n "$selected" ]; then
  target=${selected%%	*}
  tmux switch-client -t "$target"
fi
