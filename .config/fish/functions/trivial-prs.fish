# Run /review-trivial-prs every 30m in a detached tmux session (attach: tmux attach -t trivial-prs).
function trivial-prs
    tmux new -d -s trivial-prs -c ~/couchbase-cloud "claude --settings '{\"enabledPlugins\":{\"context-mode@context-mode\":false}}' '/loop 30m /couchbase-cloud:review-trivial-prs --dry-run'"
end
