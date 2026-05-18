#!/usr/bin/env bash
# Captures current pane output and opens it in nvim.
# Usage: capture-to-nvim.sh popup|window
set -e

mode="${1:-popup}"

mkdir -p /tmp/tmux-captures
tmux capture-pane -peS -32768 \
  | awk 'BEGIN{esc=sprintf("\033")} {s=$0; gsub(esc "\\[[0-9;]*[a-zA-Z]", "", s); if (s ~ /[^[:space:]]/) last=NR; line[NR]=$0} END{for(i=1;i<=last;i++) print line[i]}' \
  > /tmp/tmux-capture.txt
cp /tmp/tmux-capture.txt "/tmp/tmux-captures/$(date +%Y%m%d_%H%M%S).txt"
ls -t /tmp/tmux-captures/*.txt 2>/dev/null | tail -n +21 | xargs rm -f 2>/dev/null || true

nvim_cmd="NVIM_APPNAME=nvim-capture nvim -c 'setlocal buftype=nofile bufhidden=wipe noswapfile conceallevel=3' -c 'lua require(\"baleia\").setup({}).once(0)' -c 'normal! G' /tmp/tmux-capture.txt"

if [ "$mode" = "popup" ]; then
  tmux display-popup -E -b rounded -S fg=#DCD7BA -w 90% -h 90% "$nvim_cmd"
else
  tmux new-window -n capture "$nvim_cmd"
fi
