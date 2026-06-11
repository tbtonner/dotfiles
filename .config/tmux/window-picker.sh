#!/usr/bin/env bash
set -euo pipefail

selected=$(tmux list-windows -a -F '#{session_name}:#{window_index}	#{session_name} · #{window_name}' \
  | fzf --ansi \
        --no-input \
        --no-info \
        --delimiter='	' \
        --with-nth=2 \
        --prompt='search> ' \
        --header='j/k=move  g/G=top/bottom  enter=switch  /=search  esc=quit' \
        --preview='tmux capture-pane -ep -t {1} 2>/dev/null' \
        --preview-window='right:60%' \
        --bind='j:down,k:up,g:first,G:last' \
        --bind='/:show-input+unbind(j,k,g,G)' \
        --bind='ctrl-/:toggle-preview' || true)

if [ -n "$selected" ]; then
  target=${selected%%	*}
  tmux switch-client -t "$target"
fi
