# On macOS lazydocker looks in ~/Library/Application Support/lazydocker unless XDG_CONFIG_HOME is set, so point it at
# the stowed ~/.config/lazydocker. On Linux this is already the default, so it's a no-op there.
function lazydocker --wraps lazydocker
    XDG_CONFIG_HOME=$HOME/.config command lazydocker $argv
end
