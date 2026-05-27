function branchgotest
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

    set -l dirs (git -C $root diff $target --name-only --diff-filter=d | rg '\.go$' | xargs -I{} dirname {} | sort -u)
    if test (count $dirs) -eq 0
        echo "No changed Go files vs $target"
        return 0
    end

    set -l pkgs
    for d in $dirs
        set -a pkgs ./$d
    end

    echo "# Running tests in: $dirs"
    gotestsum --format testdox -- -count=1 $pkgs
end
