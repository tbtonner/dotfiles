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
config.window_decorations = "RESIZE" -- no title bar; komorebi tiles the window
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.adjust_window_size_when_changing_font_size = false

-- rendering (fps settings are u8 in wezterm, so 255 is the max)
config.max_fps = 255
config.animation_fps = 255
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

-- start windowed
config.initial_cols = 159
config.initial_rows = 43

-- cursor
config.default_cursor_style = "SteadyBlock"

-- scrollback
config.scrollback_lines = 10000

-- font (Maple Mono NF bundled in ./fonts; wezterm's built-in Nerd Font symbols cover any gaps)
config.font_dirs = { wezterm.config_dir .. "/fonts" }
config.font = wezterm.font("Maple Mono NF")
config.font_size = 13
-- dim (SGR 2) text: wezterm dims only by dropping to a Light weight (no colour change),
-- so keep Regular weight and grey it out with kanagawa's comment colour instead
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

-- no title bar (komorebi tiles the window), so Alt + left-drag moves it instead. Two bindings: tmux has mouse
-- reporting on, and wezterm only applies a binding while an app captures the mouse if mouse_reporting = true
config.mouse_bindings = {
    { event = { Drag = { streak = 1, button = "Left" } }, mods = "ALT", action = act.StartWindowDrag },
    { event = { Drag = { streak = 1, button = "Left" } }, mods = "ALT", action = act.StartWindowDrag, mouse_reporting = true },
}

-- nvim keybindings (same as ghostty)
config.keys = {
    { key = "Tab",   mods = "CTRL", action = act.SendString("\x14") },
    { key = "Enter", mods = "CTRL", action = act.SendString("\x15") },
    -- clear screen, keep scrollback (overrides default debug overlay)
    -- fish binds ¬ to clear (tmux eats C-l for pane nav)
    { key = "L", mods = "CTRL|SHIFT", action = act.SendString("¬") },
    { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
    { key = "V", mods = "CTRL|SHIFT", action = act.SendString("\x16") },
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

-- links clicked in wezterm open via Windows, not WSL's firefox-win, so do its komorebi jump here too: open the link,
-- then (if komorebi runs) switch to the workspace holding Firefox. The config dir is read from the registry because
-- wezterm's inherited environment can be stale.
wezterm.on("open-uri", function(_, _, uri)
    if not wezterm.target_triple:find("windows") then
        return -- default handling
    end
    wezterm.open_with(uri)
    wezterm.background_child_process({
        "powershell.exe", "-NoProfile", "-WindowStyle", "Hidden", "-Command",
        "if (Get-Process komorebi -ErrorAction SilentlyContinue) { Start-Sleep -Milliseconds 500; "
            .. "$env:KOMOREBI_CONFIG_HOME = [Environment]::GetEnvironmentVariable('KOMOREBI_CONFIG_HOME', 'User'); "
            .. "& 'C:\\Program Files\\komorebi\\bin\\komorebic.exe' eager-focus firefox.exe }",
    })
    return false
end)

return config
