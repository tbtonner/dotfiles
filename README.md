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
```
