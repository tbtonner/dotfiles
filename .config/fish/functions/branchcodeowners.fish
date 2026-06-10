function branchcodeowners
    set -l target
    if test (count $argv) -gt 0
        set target $argv[1]
    else
        set target origin/main
    end

    set -l root (git rev-parse --show-toplevel)
    if test -z "$root"
        return 1
    end

    set -l files (git -C $root diff $target --name-only --diff-filter=d)
    if test (count $files) -eq 0
        echo "No changed files vs $target"
        return 0
    end

    codeowners -f $root/.github/CODEOWNERS $files | awk '
        {
            file = $1
            for (i = 2; i <= NF; i++) print $i "\t" file
        }
    ' | sort | awk -F'\t' '
        {
            if ($1 != prev) {
                if (prev != "") print ""
                print $1
                prev = $1
            }
            print "    " $2
        }
    '
end
