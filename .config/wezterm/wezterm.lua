-- WezTerm on Windows -> WSL Arch -> fish -> tmux (fish auto-execs tmux on WSL).
-- Windows reads this from %USERPROFILE%\.config\wezterm\wezterm.lua (copy it there;
-- symlinks across the WSL boundary aren't reliable). Fonts load from ./fonts.
local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- shell
if wezterm.target_triple:find("windows") then
    config.default_domain = "WSL:archlinux"
end

-- don't prompt on close
config.window_close_confirmation = "NeverPrompt"

-- window: tmux owns tabs/status, so no tab bar
config.enable_tab_bar = false
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 4, right = 4, top = 4, bottom = 0 }
config.adjust_window_size_when_changing_font_size = false

-- rendering (fps settings are u8 in wezterm, so 255 is the max)
config.max_fps = 255
config.animation_fps = 255
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- start windowed
config.initial_cols = 140
config.initial_rows = 40

-- cursor
config.default_cursor_style = "SteadyBlock"

-- scrollback
config.scrollback_lines = 10000

-- font (Maple Mono NF bundled in ./fonts; wezterm's built-in Nerd Font symbols cover any gaps)
config.font_dirs = { wezterm.config_dir .. "/fonts" }
config.font = wezterm.font("Maple Mono NF")
config.font_size = 13
config.font_rules = {
    { intensity = "Half", italic = false, font = wezterm.font("Maple Mono NF", { weight = "Regular", foreground = "#727169" }) },
    { intensity = "Half", italic = true,  font = wezterm.font("Maple Mono NF", { weight = "Regular", style = "Italic", foreground = "#727169" }) },
}

-- QoL polish
config.hide_mouse_cursor_when_typing = true
config.audible_bell = "Disabled"
-- the click that focuses the window shouldn't reach tmux: a slight drag becomes a
-- mouse selection that copy-pipes a "\n" over the Windows clipboard
config.swallow_mouse_click_on_window_focus = true

-- nvim keybindings (same as ghostty)
config.keys = {
    { key = "Tab",   mods = "CTRL", action = act.SendString("\x14") },
    { key = "Enter", mods = "CTRL", action = act.SendString("\x15") },
    -- clear screen, keep scrollback (overrides default debug overlay)
    -- fish binds ¬ to clear (tmux eats C-l for pane nav)
    { key = "L", mods = "CTRL|SHIFT", action = act.SendString("¬") },
}

-- kanagawa theme
config.colors = {
    background = "#1F1F28",
    foreground = "#DCD7BA",
    selection_bg = "#2D4F67",
    selection_fg = "#C8C093",
    cursor_bg = "#C8C093",
    cursor_fg = "#1F1F28",
    cursor_border = "#C8C093",
    scrollbar_thumb = "#16161D",
    split = "#16161D",
    ansi = { "#16161D", "#C34043", "#76946A", "#C0A36E", "#7E9CD8", "#957FB8", "#6A9589", "#C8C093" },
    brights = { "#727169", "#E82424", "#98BB6C", "#E6C384", "#7FB4CA", "#938AA9", "#7AA89F", "#DCD7BA" },
    indexed = { [16] = "#FFA066", [17] = "#FF5D62" },
}

return config
