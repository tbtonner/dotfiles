if status is-interactive
    and not set -q TMUX
    and test -f /etc/arch-release
    tmux new-session -A -s main
    # .wslconfig disables the idle timeouts so tmux survives closing WezTerm (that
    # SIGHUPs this shell, so nothing below runs). Exiting tmux properly leaves no
    # server behind: shut the WSL VM down. A detach keeps the server, so just exit.
    if not tmux has-session 2>/dev/null
        wsl.exe --shutdown
    end
    exit
end
