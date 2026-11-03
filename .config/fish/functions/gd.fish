# Diff the working tree against HEAD, untracked files included. Stages everything into a throwaway copy of the index,
# so the real index (and what `git commit` would take) is left alone. Respects .gitignore.
# With arguments it is plain `git diff $argv`.
function gd --wraps 'git diff' --description 'git diff HEAD, including untracked files'
    if set -q argv[1]
        git diff $argv
        return
    end
    set -l index (git rev-parse --git-path index); or return
    set -l tmp (mktemp)
    test -e $index; and cp $index $tmp
    GIT_INDEX_FILE=$tmp git add -A
    GIT_INDEX_FILE=$tmp git diff --cached HEAD
    set -l code $status
    rm -f $tmp
    return $code
end
