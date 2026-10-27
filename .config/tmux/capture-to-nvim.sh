#!/usr/bin/env bash
# Captures current pane output and opens it in nvim.
# Usage: capture-to-nvim.sh popup|window
set -e

mode="${1:-popup}"

capdir="${TMPDIR:-/tmp}/tmux-captures-$(id -u)"
capfile="$capdir/latest.txt"
mkdir -p "$capdir"
tmux capture-pane -peS -32768 \
  | awk 'BEGIN{esc=sprintf("\033")} {s=$0; gsub(esc "\\[[0-9;]*[a-zA-Z]", "", s); if (s ~ /[^[:space:]]/) last=NR; line[NR]=$0} END{for(i=1;i<=last;i++) print line[i]}' \
  > "$capfile"
cp "$capfile" "$capdir/$(date +%Y%m%d_%H%M%S).txt"
ls -t "$capdir"/2*.txt 2>/dev/null | tail -n +21 | xargs rm -f 2>/dev/null || true

# nvim-capture/init.lua makes capture files a read-only, ANSI-coloured scratch view.
nvim_cmd="$HOME/.config/nvim-capture/bin/nvim-capture '$capfile'"

if [ "$mode" = "popup" ]; then
  tmux display-popup -E -b rounded -S fg=#DCD7BA -w 90% -h 90% "$nvim_cmd"
else
  tmux new-window -n capture "$nvim_cmd"
fi
