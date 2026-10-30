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

## Couchbase Cloud prod data

- For prod control-plane data, query supportal (an XDCR copy of prod, so it can lag slightly) with
  `.bin/cbc-qldb` / `.bin/cbc-qldb-row` from `couchbase-cloud`:
  `cbc-qldb-row --url "$SUPPORTAL_URL" --user "$SUPPORTAL_DB_USER" --password "$SUPPORTAL_DB_PASS" '<SELECT ...>'`.
  The three variables are exported in my shell; reference them, never print or echo their values. `--url` queries
  run read-only. Needs the VPN. The `--url` flag lands with AV-150112; until that merges, run it from that branch.

## Couchbase Cloud pull requests

- Drop the "Template Selection" section from the PR template entirely when opening a couchbase-cloud PR. This
  overrides the couchbase-claude plugin's "keep every section, Template Selection included"; keep all the others.

## Code style

- Keep code flat: around 3 levels of indentation at most. Extract named helpers rather than nesting closures or
  conditionals. Table-driven tests and HCL are obvious exceptions.
- Comment only what a reader can't see from the code: a workaround, an odd constraint, a non-obvious why. Don't
  narrate what the code plainly does. The exception is functions and methods: give each new one a brief description
  above it.
- Wrap comments at 120 columns. Treat 120 as a soft limit for code: go over it when wrapping would hurt readability.
- Go: use modern `range` loops (`for i := range n`, `for range n`) instead of C-style counter loops, unless you need an
  unusual step, a decrement, or to mutate the counter.
