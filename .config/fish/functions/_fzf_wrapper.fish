function _fzf_wrapper --description "Prepares some environment variables before executing fzf."
    # Make sure fzf uses fish to execute preview commands, some of which
    # are autoloaded fish functions so don't exist in other shells.
    # Use --function so that it doesn't clobber SHELL outside this function.
    set -f --export SHELL (command --search fish)

    # If FZF_DEFAULT_OPTS is not set, then set some sane defaults.
    # See https://github.com/junegunn/fzf#environment-variables
    if not set --query FZF_DEFAULT_OPTS
        set --export FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*" --bind ctrl-j:down,ctrl-k:up,ctrl-d:half-page-down,ctrl-u:half-page-up --color=border:#DCD7BA'
    end

    if set --query TMUX
        fzf-tmux -p 90%,85% -- $argv
    else
        fzf $argv
    end
end
