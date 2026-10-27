function gd --wraps='git diff' --description 'git diff HEAD including untracked files'
    # Everything since HEAD: staged, unstaged and untracked. Untracked files are marked intent-to-add in a throwaway
    # copy of the index, so they diff as new files without touching the real index.
    set -l index (git rev-parse --path-format=absolute --git-path index); or return
    # -unormal uses the fsmonitor/untracked cache and collapses untracked dirs, so `git add` only scans those paths.
    set -l untracked (git status --porcelain -z -unormal | string split0 | string replace -rf '^\?\? ' ':(top,literal)')
    if test (count $untracked) -eq 0
        git diff HEAD $argv
        return
    end

    set -l tmp (mktemp)
    cp $index $tmp
    GIT_INDEX_FILE=$tmp git add --intent-to-add -- $untracked
    GIT_INDEX_FILE=$tmp git diff HEAD $argv
    set -l code $status
    rm -f $tmp
    return $code
end
