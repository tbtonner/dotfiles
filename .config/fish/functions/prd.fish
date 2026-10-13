function prd --description 'Show a GitHub PR diff through delta, excluding tests and bazel files (PR number/URL/branch; default: current branch)'
    # extra args (e.g. --name-only) go to gh pr diff
    set -l exclude '(_test[.]go|[.]bazel|[.]bzl|(^|/)BUILD)$'
    if contains -- --name-only $argv
        gh pr diff --color=never $argv | grep -Ev $exclude
        return
    end
    # drop whole file sections whose path matches $exclude
    gh pr diff --color=never $argv \
        | awk -v re=$exclude '/^diff --git / { skip = ($NF ~ re) } !skip' \
        | delta
end
