function nvim
    # Pass through multi-argument calls and bare flags unchanged.
    if test (count $argv) -ne 1; or string match -q -- '-*' $argv[1]
        command nvim $argv
        return
    end

    set arg $argv[1]
    set file $arg
    set line ""

    # Full GitHub blob URL: https://github.com/<org>/<repo>/blob/<ref>/path/to/file.go#L42
    if string match -qr '^(https?://)?github\.com/' -- $arg
        # Strip fragment, capture line if present.
        if string match -qr '#L\d+' -- $arg
            set line (string replace -r '^.*#L(\d+).*$' '$1' $arg)
        end
        # Drop fragment, then strip everything up to and including /blob/<ref>/
        set url_path (string replace -r '#.*$' '' $arg)
        set file (string replace -r '^(https?://)?github\.com/[^/]+/[^/]+/blob/[^/]+/' '' $url_path)
        # Resolve against repo root if we can find it.
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

    # Not a file — search with rg using the path/name part as query.
    set rg_out (rg --line-number --with-filename --no-heading --color=never --smart-case --fixed-strings -- "$file" 2>/dev/null)

    # No results — let nvim handle it (new file, error, etc.).
    if test (count $rg_out) -eq 0
        command nvim $arg
        return
    end

    # Single match — open directly.
    if test (count $rg_out) -eq 1
        set parts (string split -m2 ':' $rg_out[1])
        command nvim +"$parts[2]" "$parts[1]"
        return
    end

    # Multiple matches — fzf picker (tmux popup if available).
    set input_file (mktemp)
    set output_file (mktemp)
    # Reduce each rg line to file:line — content is in the preview, not the list.
    for match in $rg_out
        set parts (string split -m2 ':' $match)
        printf '%s:%s\n' $parts[1] $parts[2]
    end > $input_file

    # Write a small sh script so quoting survives the tmux popup boundary.
    set wrapper (mktemp /tmp/nvim-picker-XXXXXX.sh)
    set preview 'bat --color=always --highlight-line {2} --style=numbers,changes {1} 2>/dev/null || cat {1}'
    printf '#!/bin/sh\n' > $wrapper
    printf 'fzf --delimiter=":" --layout=reverse --preview=%s --preview-window="right:60%%:+{2}-5" --bind="ctrl-/:toggle-preview" < %s > %s\n' \
        (string escape -- $preview) \
        (string escape -- $input_file) \
        (string escape -- $output_file) >> $wrapper
    chmod +x $wrapper

    if test -n "$TMUX"
        tmux popup -d (pwd) -w 90% -h 90% -E $wrapper
    else
        $wrapper
    end

    if test -s $output_file
        set sel (cat $output_file)
        set parts (string split -m2 ':' $sel)
        command nvim +"$parts[2]" "$parts[1]"
    end

    rm -f $input_file $output_file $wrapper
end
