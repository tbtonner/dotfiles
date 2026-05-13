if status is-interactive
    and not set -q TMUX
    and set -q KITTY_WINDOW_ID
    tmux new-session -A -s base
end
