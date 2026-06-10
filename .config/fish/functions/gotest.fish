function gotest --description "Run Go tests by name or package"
    if test (count $argv) -lt 1
        echo "Usage: gotest <test_name_or_package> [search_dir] [-- test_flags...]"
        return 1
    end

    set arg $argv[1]

    # Split remaining args into positional (search_dir) and extra flags
    # Anything starting with `-` (or after a literal `--`) is forwarded to the test binary.
    set positional
    set extra_flags
    set forward_all 0
    for a in $argv[2..]
        if test $forward_all -eq 1
            set extra_flags $extra_flags $a
        else if test "$a" = --
            set forward_all 1
        else if string match -qr '^-' -- $a
            set extra_flags $extra_flags $a
        else
            set positional $positional $a
        end
    end

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
        gotestsum --format testdox -- -count=1 ./$pkg $extra_flags
        return
    end

    # Test name search mode
    set test_name $arg
    set search_dir "."
    if test (count $positional) -ge 1
        set search_dir $positional[1]
    end

    set matches (rg --line-number --no-heading --with-filename --color=never "func .*$test_name" --glob "*_test.go" $search_dir 2>/dev/null)

    if test (count $matches) -eq 0
        echo "No test matching '$test_name' found in '$search_dir'"
        return 1
    end

    # Collect unique package dirs from file:line:content matches
    set pkg_dirs
    for m in $matches
        set d (dirname (string split -m1 ':' $m)[1])
        if not contains $d $pkg_dirs
            set pkg_dirs $pkg_dirs $d
        end
    end

    # fzf picker when multiple packages match
    if test (count $pkg_dirs) -gt 1
        if command -q fzf
            set -l preview 'bat --color=always --highlight-line {2} --style=numbers,changes {1} 2>/dev/null || cat {1}'
            set -l selected (for m in $matches
                set -l parts (string split -m2 ':' $m)
                printf '%s:%s\n' $parts[1] $parts[2]
            end | _fzf_pick \
                -m +i --delimiter=: \
                "--prompt=matches> " \
                "--header=tab=toggle  ctrl-a=all  ctrl-/:preview  enter=run" \
                "--preview=$preview" \
                "--preview-window=right:60%:+{2}-5" \
                --bind=ctrl-/:toggle-preview)
            test (count $selected) -eq 0; and return 0
            # Extract unique package dirs from selected file:line entries
            set pkg_dirs
            for sel in $selected
                set -l d (dirname (string split -m1 ':' $sel)[1])
                if not contains $d $pkg_dirs
                    set pkg_dirs $pkg_dirs $d
                end
            end
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
    gotestsum --format testdox -- -run $test_name -count=1 $pkg_args $extra_flags
end
