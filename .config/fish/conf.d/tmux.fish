if status is-interactive
    and not set -q TMUX
    and test -f /etc/arch-release
    exec tmux new-session -A -s main
end
