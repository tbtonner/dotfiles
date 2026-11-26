# Scratch dir for couchbase-claude skills (review-trivial-prs seen.tsv, evidence logs). Must survive reboots.
set -gx CLAUDE_TMPDIR ~/.cache/claude-tmp
mkdir -p $CLAUDE_TMPDIR
