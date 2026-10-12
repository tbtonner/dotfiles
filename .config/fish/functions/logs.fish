function logs --description "View docker container logs through hl, picking the container by name"
    argparse h/help 't/tail=?' -- $argv
    or return 1

    if set -q _flag_help
        echo "Usage: logs [name_pattern] [-t|--tail[=N]] [-- hl_flags...]"
        echo "  logs jobs            full log history of the matching container, paged in hl"
        echo "  logs jobs --tail     follow the last 200 lines live"
        echo "  logs jobs --tail=50  follow the last 50 lines live"
        return 0
    end

    set -l pattern $argv[1]
    set -l hl_flags $argv[2..]

    # "name  status" for every container (stopped ones too, so crashed services can be inspected).
    # Space-separated rather than tab: _fzf_pick re-quotes args for sh, which mangles a \t delimiter,
    # and container names never contain spaces so fzf's default {1} field is the name.
    set -l containers (docker ps -a --format '{{.Names}}  {{.Status}}')
    or return 1
    if test -n "$pattern"
        # Match against the name only, not the status column
        set -l matched
        for c in $containers
            string match -qei -- $pattern (string split -f1 ' ' -- $c)
            and set matched $matched $c
        end
        set containers $matched
    end

    if test (count $containers) -eq 0
        echo "No container matching '$pattern'"
        return 1
    end

    # fzf picker when multiple containers match
    set -l name
    if test (count $containers) -eq 1
        set name (string split -f1 ' ' -- $containers[1])
    else
        set -l preview 'docker logs --tail 100 {1} 2>&1 | hl -c -P'
        set -l selected (printf '%s\n' $containers | _fzf_pick \
            "--header=j/k=move  g/G=top/bottom  enter=view  /=search  ctrl-/:preview  q=quit" \
            "--preview=$preview" \
            "--preview-window=right:60%:follow" \
            --bind=ctrl-/:toggle-preview)
        test (count $selected) -eq 0; and return 0
        set name (string split -f1 ' ' -- $selected[1])
    end

    if set -q _flag_tail
        set -l n 200
        test -n "$_flag_tail"; and set n $_flag_tail
        echo "# Following $name (last $n lines)"
        docker logs -f --tail $n $name 2>&1 | hl -P $hl_flags
    else
        docker logs $name 2>&1 | hl $hl_flags
    end
end
