---
name: ship-pr
description: Take a change from working code to a reviewed draft PR. Commit in logical pieces, push a draft PR (stacked with `gh stack` when there are several), get an independent no-context review, apply the agreed findings, answer every Copilot comment, then do a code style pass and hand over for manual review and testing. Use when asked to make, open or raise a PR or a stack of PRs, or with `/ship-pr [ticket...]`.
---

# ship-pr

Run each phase in order for every PR. With a stack, finish phase 1 for all layers first, so the reviews run on the
final shape of the stack, then run phases 2 to 5 per PR, from the bottom of the stack up.

The repo's own rules (`AGENTS.md`, `CLAUDE.md`, the PR template) win over anything here. Read them before writing a
PR description.

## 1. Commit, push, open a draft PR

1. **Split the commits so each one makes sense on its own:** a refactor before the behaviour that needs it, generated
   code (`make gazelle`, mocks, goof errors) with the change that needs it, and tests with the code they test. Every
   commit builds. Subject: `<TICKET> <imperative summary>`. Wrap the body at 72 columns and say why, not what.
2. **Run the unit tests and lint for the touched packages** before pushing. Fix failures; don't push red.
3. **Push and open the PR as a draft.**
   - One PR: `gh pr create --draft`.
   - A stack: track it with `gh stack` (`gh stack add -Am "<TICKET> <summary>" <TICKET>_<snake_summary>` per layer
     from the top branch, then `gh stack submit`). Never hand-link PRs. Then set each PR's title, body and draft state.
   - Fill the repo's PR template. Leave manual testing (cbclocal) unticked and say it is still to do.
4. **couchbase-cloud only: request a Copilot review** (`gh pr edit <n> --add-reviewer @copilot`). Check it took with the
   GraphQL `reviewRequests` field (login `copilot-pull-request-reviewer`); REST hides bot reviewers.

## 2. Independent review

Start a fresh `general-purpose` agent for each PR. Give it the PR number and repo, and nothing about your own
reasoning or what you think is fine. Ask it to read the diff and the code around it, and report findings with
`path:line`, severity and a concrete failure scenario, on:

- **Other places the change should apply:** other cloud providers, other callers of a changed function, sibling
  code paths (deploy vs update vs delete vs expiry), other resource types with the same pattern.
- **Backwards compatibility:** stored documents without the new fields, existing deployed infrastructure, API
  responses and error codes, rolling deploys where old and new versions run side by side, retries of half-done work.
- **Correctness:** races, error paths, partial failure, fail-open vs fail-closed in security code.
- Anything the PR description claims that the code does not do.

Run the agents for all PRs in parallel.

## 3. Apply the review

For each finding, decide: agree, disagree, or out of scope. Verify against the code before agreeing; the reviewer
can be wrong. Apply the ones you agree with as follow-up commits (one per logical fix, never amend or force-push
reviewed commits), run the tests, push. With a stack, fix the lowest PR the finding belongs to, then `gh stack sync`
to carry it up; confirm with the user first, since `sync` force-pushes every branch.

Keep a list of each finding, the decision, and the commit or reason. It goes in the final report.

## 4. Copilot review

1. **Wait for it.** Check `gh api repos/<o>/<r>/pulls/<n>/reviews` for a review by `copilot-pull-request-reviewer`.
   If it is not there, wait (Monitor with an until-loop, polling about every 60s, up to 15 minutes). If it still has
   not come, say so and move on.
2. **Handle every inline comment** (`gh api repos/<o>/<r>/pulls/<n>/comments`, those by the Copilot bot):
   - Agree: fix it in a follow-up commit, push, then reply `Done in <short-sha>.`
   - Disagree or out of scope: reply with the reason in one or two sentences (why it does not apply, or which ticket
     will cover it).
   - Reply in the thread: `gh api repos/<o>/<r>/pulls/<n>/comments/<id>/replies -f body=...`. Follow the user's
     comment rules (AI disclaimer line etc.).
3. Don't resolve threads; the author does that.

## 5. Code style pass, then hand over

1. **Style pass:** review the PR's full diff against the user's Code style rules in `~/.claude/CLAUDE.md` and the
   repo conventions. The `go-style-check.sh` hook only catches mechanical patterns on each edit; this pass covers the
   judgement rules (flat code, helpers over nesting, naming steps, assign once, comments only for the non-obvious,
   error wrapping, smallest change). Fix in a follow-up commit and push.
2. **Stop.** Don't run manual or cbclocal testing; the user does a pass on the code first.
3. **Report** per PR: link, commits, review findings with decision and commit/reason, Copilot comments with reply,
   and what is left (manual testing, anything deferred).
