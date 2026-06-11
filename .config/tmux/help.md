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
| `w` | window picker across all sessions (popup, hjkl) |

## Sessions

| Key | Action |
|---|---|
| `[` / `]` | prev / next session |
| `S` | new session (current path) |
| `.` | rename session |
| `f` | session picker (popup, hjkl) |
| `K` | kill session(s) (popup, hjkl, tab multi-select) |

### Inside a picker

| Key | Action |
|---|---|
| `j` / `k` | move down / up |
| `g` / `G` | jump to top / bottom |
| `enter` | accept |
| `tab` | toggle select (kill picker only) |
| `/` | switch to fuzzy search |
| `ctrl-/` | toggle preview |
| `esc` | close picker |

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
