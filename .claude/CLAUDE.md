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

- For prod control-plane data, query supportal (an XDCR copy of prod, so it can lag slightly) with the `supportal`
  fish function: `fish -c 'supportal "<SELECT ...>"'`. It wraps `cbc-qldb --url/--user/--password` with the
  exported `SUPPORTAL_*` variables and returns the full results array; never print or echo their values. For a single
  row, call `.bin/cbc-qldb-row` with the same three flags. Queries run read-only and need the VPN.
- A query containing `.env` (e.g. `a.environment`) trips the secret-file hook. Write it to a scratchpad file and pass
  `(cat <file> | string collect)` instead.

## Couchbase Cloud logs

- When I send a Datadog link, don't open it in Datadog. Read its query, filters and time range from the URL, translate
  them to DataPrime and search Coralogix instead.

## Couchbase Cloud local stack (cbclocal)

- When I say I have cbclocal up, use my default stack (`CBCLOCAL_INSTANCE=default`, `http://localhost:<port>`); don't
  start your own instance. Restarting a service on it with changed code is fine once I've agreed to it.
- `JWT`, `V4`, `INTERNAL_SUPPORT_TOKEN`, `TENANT_ID` and `PROJECT_ID` are not exported to your shell. Use these fish
  equivalents instead, inside `fish -c '...'` or a `cbc-evidence` command (which runs fish):
  - JWT: the `jwt` fish function, e.g. `http -A bearer -a (jwt) GET http://localhost:8080/v2/...`.
  - Tenant (organisation) ID: `$localoid`. Project ID: `$localpid`. These are plain fish variables, not exported, so
    jq's `env.` can't see them; pass them with `jq --arg`.
  - Internal support routes (`http://localhost:8080/internal/support/...`):
    `-A bearer -a the-secret-token-for-internal-support`. This is the fixed local-only token, not a secret.
- AWS profile for cbclocal (cluster deploys, `cbc-https`, ...): `AWS_PROFILE=dbaas-test-0005-temp`.
- Feature flags: ignore LaunchDarkly locally. Defaults come from `internal/featureflags/v2/service/feature_flags.json`.
  To flip one, use the internal API: `PUT http://localhost:8080/internal/support/features/flags/<name>` with body
  `{"value": true}` (support token auth).
- `$CLAUDE_TMPDIR` can be empty; put evidence logs and `payload.json` files in the session scratchpad instead.

## Couchbase Cloud commits and pull requests

- If a git hook blocks a commit in couchbase-cloud, commit again with `--no-verify`.
- Drop the "Template Selection" section from the PR template entirely when opening a couchbase-cloud PR. This
  overrides the couchbase-claude plugin's "keep every section, Template Selection included"; keep all the others.
- Manage stacked PRs with local `gh stack` tracking, never by creating PRs by hand and linking them (`gh stack link`
  makes only the GitHub stack object, so `gh stack view` and `sync` can't see it). New stack: `gh stack init`,
  `gh stack add <branch>` per layer, `gh stack submit`. Stack that exists only on GitHub: `gh stack checkout
  <stack-number|pr-number>` imports it. Keep it in sync, including after a lower PR gains commits ("Some branches in
  this stack have diverged"), with `gh stack sync`. It rebases and force-pushes every branch, so confirm first.
- Reach for `gh stack add` first when starting the next layer of a stack. From the top branch,
  `gh stack add -Am "AV-1234 Do the thing" AV-1234_brief_snake_summary` creates the branch on top, commits all changes
  and tracks it in one step; `gh stack submit` then pushes it and opens the PR with the right base. Always pass the
  branch name: without one it is generated from the commit message and breaks the `AV-1234_...` naming.

## Code style

- Keep code flat: around 3 levels of indentation at most. Extract named helpers rather than nesting closures or
  conditionals. Table-driven tests and HCL are obvious exceptions.
- Comment only what a reader can't see from the code: a workaround, an odd constraint, a non-obvious why. Don't
  narrate what the code plainly does. The exception is functions and methods: give each new one a brief description
  above it.
- Test files are stricter: no doc comments on test functions or helpers, not even new ones. Comment only something odd
  that needs explaining.
- Match the comment style of the surrounding code first. If the neighbouring declarations in a block (consts, vars,
  fields, functions) carry no doc comments, don't add one to the new entry, even where the rule above would.
- Wrap comments at 120 columns. Treat 120 as a soft limit for code: go over it when wrapping would hurt readability.
- Go: when a function signature has to wrap, put every parameter on its own line with a trailing comma; never pack
  several per line.
- Go: give every parameter its own type, even when neighbours share one (`tenantID string, cardID string`, not
  `tenantID, cardID string`).
- Go: use modern `range` loops (`for i := range n`, `for range n`) instead of C-style counter loops, unless you need an
  unusual step, a decrement, or to mutate the counter.
