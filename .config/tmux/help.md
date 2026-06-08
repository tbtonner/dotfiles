# tmux bindings

Prefix: `C-a`

## Panes

| Key | Action |
|---|---|
| `v` | split vertical (side-by-side) |
| `s` | split horizontal (top/bottom) |
| `d` | kill pane |
| `C-h` / `C-j` / `C-k` / `C-l` | move between panes (no prefix; vim-aware) |

## Windows

| Key | Action |
|---|---|
| `c` | new window (current path) |
| `h` / `l` | prev / next window |
| `,` | rename window |
| `x` | kill window |

## Sessions

| Key | Action |
|---|---|
| `[` / `]` | prev / next session |
| `S` | new session (current path) |
| `f` | session picker (fzf popup) |
| `w` | window picker across all sessions (fzf popup) |
| `K` | kill session(s) (fzf multi-select) |

## Copy / paste

| Key | Action |
|---|---|
| `e` | enter copy-mode |
| `v` | (in copy-mode) begin selection |
| `y` | (in copy-mode) copy → pbcopy |
| `P` | paste buffer |

## Capture

| Key | Action |
|---|---|
| `a` | capture pane → nvim popup |
| `A` | capture pane → nvim new window |

## Help

| Key | Action |
|---|---|
| `H` | this cheatsheet |

> press `q` to close
