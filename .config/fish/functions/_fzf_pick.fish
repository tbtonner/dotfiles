function _fzf_pick --description "fzf picker with tmux popup; reads items from stdin, prints selections to stdout"
    set -l input_file (mktemp)
    set -l output_file (mktemp)
    set -l wrapper (mktemp /tmp/fzf-pick-XXXXXX.sh)

    cat > $input_file

    # Escape each arg for sh; bake in shared style defaults first.
    # Start in "normal mode" like the tmux pickers: input hidden, j/k to move, / to search, q to quit.
    # Callers can override --prompt/--header since later flags win.
    set -l args_parts --layout=reverse '--color=preview-border:#DCD7BA' \
        --no-input --no-info '--prompt=search> ' \
        '--header=j/k=move  g/G=top/bottom  /=search  q=quit' \
        --bind=j:down,k:up,g:first,G:last,q:abort '--bind=/:show-input+unbind(j,k,g,G,q)' \
        $argv
    set -l args_str
    for arg in $args_parts
        set args_str $args_str (string escape -- $arg)
    end

    printf '#!/bin/sh\nfzf %s < %s > %s\n' \
        (string join -- ' ' $args_str) \
        (string escape -- $input_file) \
        (string escape -- $output_file) > $wrapper
    chmod +x $wrapper

    if test -n "$TMUX"
        tmux popup -d (pwd) -w 90% -h 90% -b rounded -S fg=#DCD7BA -E $wrapper
    else
        $wrapper
    end

    test -s $output_file; and cat $output_file
    rm -f $input_file $output_file $wrapper
end
