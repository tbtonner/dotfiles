# Global instructions

Shared across all my machines (macOS and Arch Linux) via `~/dotfiles`, stowed to `~/.claude/CLAUDE.md`.

## Communication

- Always write in UK English: spelling ("behaviour", "colour", "randomise"), vocabulary and phrasing.
- Name files by their full repo-relative path (`internal/csp/jobs/quota.go`, not `quota.go`), both in your responses and
  in PR reviews. Short filenames are ambiguous in a large repo.

## Shell and tools

- My shell is fish. Any command you show me must use fish syntax (`set VAR value`, not `export VAR=value`). The Bash
  tool itself still runs bash; only the commands you show me need to be fish.
- Prefer `fd` over `find` and `rg` over `grep`, both in tool calls and in commands you suggest.

## Dotfiles

- Every change to `~/dotfiles` must work on both macOS and Arch Linux; I switch between machines running each. Watch
  for BSD vs GNU tools (`sed -i`, `date`, `stat`), Homebrew vs pacman paths (`/opt/homebrew` vs `/usr`), clipboard
  (`pbcopy` vs `wl-copy`) and tmux behaving differently per OS. Guard OS-specific bits with a conditional (e.g.
  `if-shell 'uname | grep -q Darwin'` in tmux, `switch (uname)` in fish), and tell me how a change behaves on each OS.
- The dotfiles are managed with GNU stow (`cd ~/dotfiles; stow .`). New files go in `~/dotfiles` and get linked into
  place; never edit the linked copies under `~` as if they were separate files.

## Code style

- Keep code flat: around 3 levels of indentation at most. Extract named helpers rather than nesting closures or
  conditionals. Table-driven tests and HCL are obvious exceptions.
- Wrap comments at 120 columns. Treat 120 as a soft limit for code: go over it when wrapping would hurt readability.
- Go: use modern `range` loops (`for i := range n`, `for range n`) instead of C-style counter loops, unless you need an
  unusual step, a decrement, or to mutate the counter.
