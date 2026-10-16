function gg --wraps='git push' --description 'git gud (push --no-verify), then request a Copilot review on the PR if it has not had one'
    git gud $argv; or return

    # Copilot review is only required by couchbasecloud/couchbase-cloud's PR review gate.
    string match -qr 'github\.com[:/]couchbasecloud/couchbase-cloud(\.git)?$' -- (git remote get-url origin 2>/dev/null)
    or return 0

    # Fails when the branch has no PR yet; nothing to request then.
    set -l has_copilot (gh pr view --json reviews,reviewRequests \
        --jq '[.reviews[].author.login, (.reviewRequests[] | .login // .name // "")] | map(ascii_downcase) | any(contains("copilot"))' 2>/dev/null)
    or return 0

    # Only request once: re-requesting makes Copilot review again and can reopen the review gate.
    if test "$has_copilot" = false
        gh pr edit --add-reviewer @copilot >/dev/null; and echo "Requested Copilot review"
    end
end
