# Ctrl-C handler: cancel-commandline leaves the abandoned line on screen, unlike fish's default of clearing it.
function __ctrl_c_keep_line
    commandline --function cancel-commandline
end
