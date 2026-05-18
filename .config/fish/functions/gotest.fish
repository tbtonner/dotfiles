function gotest --description "Run Go tests by name or package"
    if test (count $argv) -lt 1
        echo "Usage: gotest <test_name_or_package> [search_dir]"
        return 1
    end

    set arg $argv[1]

    # Package/path mode: existing dir, existing .go file, or ends with ...
    if test -d $arg; or test -f $arg; or string match -q '*...' $arg
        set pkg (string replace -r '^\./' '' $arg)
        # If it's a .go file, use its directory as the package
        if string match -q '*.go' $pkg
            set pkg (dirname $pkg)
        end
        if not string match -q '*...' $pkg
            set pkg "$pkg/..."
        end
        echo "# Running all tests in ./$pkg"
        gotestsum --format testdox -- -count=1 ./$pkg
        return
    end

    # Test name search mode
    set test_name $arg
    set search_dir "."
    if test (count $argv) -ge 2
        set search_dir $argv[2]
    end

    set matches (rg -l "func .*$test_name" --glob "*_test.go" $search_dir 2>/dev/null)

    if test (count $matches) -eq 0
        echo "No test matching '$test_name' found in '$search_dir'"
        return 1
    end

    # Collect unique package dirs
    set pkg_dirs
    for m in $matches
        set d (dirname $m)
        if not contains $d $pkg_dirs
            set pkg_dirs $pkg_dirs $d
        end
    end

    # fzf picker when multiple packages match
    if test (count $pkg_dirs) -gt 1
        if command -q fzf
            set selected (printf '%s\n' $pkg_dirs | _fzf_wrapper --multi \
                --prompt="packages> " \
                --header="tab=toggle  ctrl-a=all  enter=run")
            if test $status -ne 0; or test (count $selected) -eq 0
                return 0
            end
            set pkg_dirs $selected
        else
            echo "# Multiple packages found:"
            for d in $pkg_dirs
                echo "#   $d"
            end
        end
    end

    set pkg_args
    for d in $pkg_dirs
        set pkg_args $pkg_args ./$d
    end

    echo "# Running '$test_name' in: $pkg_dirs"
    gotestsum --format testdox -- -run $test_name -count=1 $pkg_args
end
