function branchgofmt
    set -l target branch
    if test (count $argv) -gt 0
        set target $argv[1]
    else
        set target origin/main
    end

    git diff $target --name-only --diff-filter=d | rg '\.go' | xargs gofmt -w
end
