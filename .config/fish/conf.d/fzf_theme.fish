# Kanagawa colours for every fzf (fish pickers, fzf.fish widgets and the tmux popup scripts).
# Lives in conf.d so it is exported before tmux.fish execs tmux, which then inherits it.
set -gx FZF_DEFAULT_OPTS_FILE ~/.config/fzf/kanagawa
