# Diff the working tree against HEAD, untracked files included. Stages everything into a throwaway copy of the index,
# so the real index (and what `git commit` would take) is left alone. Respects .gitignore.
function gd --wraps 'git diff' --description 'git diff HEAD, including untracked files'
    set -l index (git rev-parse --git-path index); or return
    set -l tmp (mktemp)
    test -e $index; and cp $index $tmp
    GIT_INDEX_FILE=$tmp git add -A
    GIT_INDEX_FILE=$tmp git diff --cached HEAD $argv
    set -l code $status
    rm -f $tmp
    return $code
end
