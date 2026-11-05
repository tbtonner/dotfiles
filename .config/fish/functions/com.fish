# Print and copy an "Updated in <commit URL>" PR comment.
# Commit: HEAD, or with -p/--pick a commit chosen by number from the commits since origin/HEAD.
# PR number: $argv[1], else the open PR for this branch, else $pullnum, else a PULLNUM placeholder.
function com
    argparse p/pick -- $argv
    or return 1

    set -l sha (__com_commit $_flag_pick)
    or return 1

    set -l p (__com_pr_number $argv)
    set -l msg "Updated in https://github.com/couchbasecloud/couchbase-cloud/pull/$p/commits/$sha"
    printf '%s' $msg | pbcopy
    echo $msg
end

# Short SHA of HEAD, or with "pick" a commit chosen from a numbered log of the commits since origin/HEAD.
function __com_commit
    if test (count $argv) -eq 0
        git rev-parse --short HEAD
        return
    end

    set -l base (git merge-base HEAD origin/HEAD)
    or return 1
    set -l commits (git rev-list $base..HEAD)
    if test (count $commits) -eq 0
        echo "com: no commits after origin/HEAD" >&2
        return 1
    end

    for i in (seq (count $commits))
        printf '%3d  %s\n' $i (git log -1 --format='%h %s' $commits[$i]) >&2
    end

    read -l -P 'Commit number [1]: ' choice </dev/tty
    test -n "$choice"; or set choice 1
    if not string match -qr '^[1-9][0-9]*$' -- $choice; or test $choice -gt (count $commits)
        echo "com: pick a number from 1 to "(count $commits) >&2
        return 1
    end

    git rev-parse --short $commits[$choice]
end

# PR number from the argument, the current branch's open PR, $pullnum, or a placeholder, in that order.
function __com_pr_number
    if test (count $argv) -ge 1
        echo $argv[1]
        return
    end

    set -l open (gh pr view --json number,state --jq 'select(.state == "OPEN") | .number' 2>/dev/null)
    if test -n "$open"
        echo $open
        return
    end

    if set -q pullnum
        echo $pullnum
        return
    end

    echo PULLNUM
end
