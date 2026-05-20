function _nvim_open_selections
    set -l key $argv[1]
    set -l sels $argv[2..]
    test (count $sels) -eq 0; and return

    set -l files
    set -l lnums
    for sel in $sels
        if string match -qr '^.+:\d+$' -- $sel
            set -l p (string split -r -m1 ':' $sel)
            set -a files $p[1]
            set -a lnums $p[2]
        else
            set -a files $sel
            set -a lnums ""
        end
    end

    switch $key
        case ctrl-v ctrl-x
            set -l split_cmd (test "$key" = ctrl-v; and echo vsplit; or echo split)
            set -l nvim_args
            if test -n "$lnums[1]"
                set nvim_args +"$lnums[1]" "$files[1]"
            else
                set nvim_args "$files[1]"
            end
            for i in (seq 2 (count $files))
                if test -n "$lnums[$i]"
                    set nvim_args $nvim_args -c "$split_cmd +$lnums[$i] $files[$i]"
                else
                    set nvim_args $nvim_args -c "$split_cmd $files[$i]"
                end
            end
            command nvim $nvim_args
        case '*'
            set -l nvim_args
            if test -n "$lnums[1]"
                set nvim_args +"$lnums[1]"
            end
            set nvim_args $nvim_args $files
            command nvim $nvim_args
    end
end

function _nvim_run_fzf
    # $argv[1] = rg | files
    # $argv[2..] = input lines
    set -l mode $argv[1]
    set -l items $argv[2..]

    set -l input_file (mktemp)
    set -l output_file (mktemp)
    set -l wrapper (mktemp /tmp/nvim-picker-XXXXXX.sh)

    if test "$mode" = rg
        for match in $items
            set -l p (string split -m2 ':' $match)
            printf '%s:%s\n' $p[1] $p[2]
        end > $input_file
        set -l preview 'bat --color=always --highlight-line {2} --style=numbers,changes {1} 2>/dev/null || cat {1}'
        printf '#!/bin/sh\nfzf -m +i --delimiter=":" --layout=reverse --color="preview-border:#DCD7BA" --preview=%s --preview-window="right:60%%:+{2}-5" --bind="ctrl-/:toggle-preview" --expect="ctrl-v,ctrl-x" < %s > %s\n' \
            (string escape -- $preview) \
            (string escape -- $input_file) \
            (string escape -- $output_file) > $wrapper
    else
        printf '%s\n' $items > $input_file
        set -l preview 'bat --color=always --style=numbers,changes {} 2>/dev/null || cat {}'
        printf '#!/bin/sh\nfzf -m +i --layout=reverse --color="preview-border:#DCD7BA" --preview=%s --preview-window="right:60%%" --bind="ctrl-/:toggle-preview" --expect="ctrl-v,ctrl-x" < %s > %s\n' \
            (string escape -- $preview) \
            (string escape -- $input_file) \
            (string escape -- $output_file) > $wrapper
    end
    chmod +x $wrapper

    if test -n "$TMUX"
        tmux popup -d (pwd) -w 90% -h 90% -b rounded -S fg=#DCD7BA -E $wrapper
    else
        $wrapper
    end

    if test -s $output_file
        set -l result (cat $output_file)
        _nvim_open_selections $result[1] $result[2..]
    end

    rm -f $input_file $output_file $wrapper
end

function nvim
    # -a: bypass smart search and open directly (e.g. new files).
    if contains -- -a $argv
        command nvim (string match -v -- '-a' $argv)
        return
    end

    # No-arg: fd-powered file picker from cwd.
    if test (count $argv) -eq 0
        set -l output_file (mktemp)
        set -l wrapper (mktemp /tmp/nvim-picker-XXXXXX.sh)
        set -l preview 'bat --color=always --style=numbers,changes {} 2>/dev/null || cat {}'
        printf '#!/bin/sh\nfd --hidden --type f . | fzf -m +i --layout=reverse --color="preview-border:#DCD7BA" --preview=%s --preview-window="right:60%%" --bind="ctrl-/:toggle-preview" --expect="ctrl-v,ctrl-x" > %s\n' \
            (string escape -- $preview) \
            (string escape -- $output_file) > $wrapper
        chmod +x $wrapper

        if test -n "$TMUX"
            tmux popup -d (pwd) -w 90% -h 90% -b rounded -S fg=#DCD7BA -E $wrapper
        else
            $wrapper
        end

        if test -s $output_file
            set -l lines (cat $output_file)
            _nvim_open_selections $lines[1] $lines[2..]
        end
        rm -f $output_file $wrapper
        return
    end

    # Pass through multi-argument calls, bare flags, and directories unchanged.
    if test (count $argv) -ne 1; or string match -q -- '-*' $argv[1]; or test -d $argv[1]
        command nvim $argv
        return
    end

    set -l arg $argv[1]
    set -l file $arg
    set -l line ""

    # Full GitHub blob URL: https://github.com/<org>/<repo>/blob/<ref>/path/to/file.go#L42
    if string match -qr '^(https?://)?github\.com/' -- $arg
        if string match -qr '#L\d+' -- $arg
            set line (string replace -r '^.*#L(\d+).*$' '$1' $arg)
        end
        set url_path (string replace -r '#.*$' '' $arg)
        set file (string replace -r '^(https?://)?github\.com/[^/]+/[^/]+/blob/[^/]+/' '' $url_path)
        set repo_root (git -C (pwd) rev-parse --show-toplevel 2>/dev/null)
        if test -n "$repo_root"
            set file "$repo_root/$file"
        end
    # GitHub fragment: path/to/file.go#L2415 or #L2415-L2417 (take first line).
    else if string match -qr '^.+#L\d+' -- $arg
        set parts (string split -m1 '#' $arg)
        set file $parts[1]
        set line (string replace -r '^L(\d+).*' '$1' $parts[2])
    # Standard :line suffix.
    else if string match -qr '^.+:\d+$' -- $arg
        set parts (string split -r -m1 ':' $arg)
        set file $parts[1]
        set line $parts[2]
    end

    # File exists — open it.
    if test -f $file
        if test -n "$line"
            command nvim +"$line" "$file"
        else
            command nvim "$file"
        end
        return
    end

    # Not a file — search content with rg.
    set -l rg_out (rg --hidden --line-number --with-filename --no-heading --color=never --smart-case --fixed-strings -- "$file" 2>/dev/null)

    if test (count $rg_out) -eq 0
        # Fall back to fd file-name search.
        set -l fd_out (fd --hidden --type f "$file" 2>/dev/null)
        if test (count $fd_out) -eq 0
            echo "nvim: no matches for '$arg'" >&2
            return 1
        end
        if test (count $fd_out) -eq 1
            command nvim "$fd_out[1]"
            return
        end
        _nvim_run_fzf files $fd_out
        return
    end

    # Single rg match — open directly.
    if test (count $rg_out) -eq 1
        set -l parts (string split -m2 ':' $rg_out[1])
        command nvim +"$parts[2]" "$parts[1]"
        return
    end

    # Multiple rg matches — fzf picker.
    _nvim_run_fzf rg $rg_out
end
