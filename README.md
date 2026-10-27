# dotfiles

Personal dotfiles managed with [stow](https://www.gnu.org/software/stow/).

## Contents

| Config | Path |
|--------|------|
| Fish shell | `.config/fish/` |
| Neovim | `.config/nvim/` |
| Tmux | `.config/tmux/tmux.conf` |
| Ghostty | `.config/ghostty/config` |
| Git | `gitconfig` |
| Taskwarrior | `.taskrc`, `.task/hooks/` |
| Atuin | `.config/atuin/config.toml` |
| Lazydocker | `.config/lazydocker/config.yml` |
| hl (Kanagawa log theme) | `.config/hl/` |
| fzf (Kanagawa colours) | `.config/fzf/kanagawa` |
| bat (Kanagawa theme) | `.config/bat/` |
| Claude Code (global instructions, settings, Kanagawa theme, git status line) | `.claude/CLAUDE.md`, `.claude/settings.json`, `.claude/themes/`, `.claude/statusline.sh` |
| komorebi tiling WM on Windows (config, bar, whkd hotkeys; not stowed) | `windows/komorebi/` |

## Tools

- **Shell**: [Fish](https://fishshell.com/) + [Fisher](https://github.com/jorgebucaran/fisher) + [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish)
- **Fish plugins**: [fzf.fish](https://github.com/patrickf1/fzf.fish)
- **Editor**: [Neovim](https://neovim.io/) with [lazy.nvim](https://github.com/folke/lazy.nvim), Kanagawa theme
- **Terminal**: [Ghostty](https://ghostty.org/)
- **Multiplexer**: [Tmux](https://github.com/tmux/tmux)

## Setup

```sh
git clone https://github.com/tbtonner/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
bat cache --build   # register .config/bat/themes
```

### WSL (Arch) + WezTerm on Windows

```sh
pacman -S stow fish tmux neovim fzf fd ripgrep bat git-delta jq base-devel unzip tree-sitter-cli wl-clipboard hl
chsh -s /usr/bin/fish            # fish auto-execs tmux when $WSL_DISTRO_NAME is set
stow .
cp .config/wezterm/wezterm.lua /mnt/c/Users/<you>/.config/wezterm/   # plus Maple Mono NF in ./fonts
```

### komorebi on Windows

The config in `windows/komorebi/` is Windows-only, so `.stow-local-ignore` keeps stow from linking it. Windows reads copies, found via two user environment variables:

```powershell
# admin PowerShell; also set HKLM\SYSTEM\CurrentControlSet\Control\FileSystem LongPathsEnabled=1
winget install LGUG2Z.komorebi; winget install LGUG2Z.whkd
[Environment]::SetEnvironmentVariable('KOMOREBI_CONFIG_HOME', "$env:USERPROFILE\.config\komorebi", 'User')
[Environment]::SetEnvironmentVariable('WHKD_CONFIG_HOME', "$env:USERPROFILE\.config\komorebi", 'User')
```

Then run `komorebi-win-sync` from WSL (copies the config and `whkdrc`, and puts `tilemanager-toggle.cmd` in Documents) and `komorebic fetch-asc` once on Windows. Start and stop everything with `Documents\tilemanager-toggle.cmd`. Hotkeys use the left Win key; Win+L only works with locking disabled (`HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System`, `DisableLockWorkstation=1`).

Machine-specific git settings (gpg path, signing) go in `~/.gitconfig.local`.
