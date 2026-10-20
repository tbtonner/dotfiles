#!/bin/sh
# Moves from a pane in direction L/D/U/R. At the edge of the window it falls through instead of wrapping:
# left/right go to the previous/next window, up/down go to the previous/next session. With only one window (or
# session) there is nowhere to fall through to, so it does nothing.
# Called by the C-hjkl bindings in tmux.conf and by nvim's C-hjkl maps when nvim has no split in that direction.
# Usage: navigate.sh L|D|U|R <pane-id>
dir=$1
pane=$2

case $dir in
L) edge=left fallback=previous-window count=session_windows ;;
R) edge=right fallback=next-window count=session_windows ;;
U) edge=top fallback=switch-client-prev count=server_sessions ;;
D) edge=bottom fallback=switch-client-next count=server_sessions ;;
*) exit 1 ;;
esac

if [ "$(tmux display-message -p -t "$pane" "#{pane_at_$edge}")" != 1 ]; then
    exec tmux select-pane -t "$pane" "-$dir"
fi

if [ "$(tmux display-message -p -t "$pane" "#{$count}")" -le 1 ]; then
    exit 0
fi

client=$(tmux display-message -p -t "$pane" '#{client_name}')
case $fallback in
previous-window | next-window) exec tmux "$fallback" -t "$pane" ;;
switch-client-prev) exec tmux switch-client -c "$client" -p ;;
switch-client-next) exec tmux switch-client -c "$client" -n ;;
esac
