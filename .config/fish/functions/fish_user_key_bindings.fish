# Extra bindings for vi normal and insert mode: Ctrl-C keeps the cancelled line visible, ¬ clears the screen.
function fish_user_key_bindings
    bind ctrl-c __ctrl_c_keep_line
    bind -M insert ctrl-c __ctrl_c_keep_line

    bind ¬ 'clear; commandline -f repaint'
    bind -M insert ¬ 'clear; commandline -f repaint'
end
