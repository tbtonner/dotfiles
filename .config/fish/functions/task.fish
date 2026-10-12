function task --wraps task --description 'Taskwarrior; bare `task` syncs first so the list is current'
    if test (count $argv) -eq 0
        tsync >/dev/null; or echo "task: sync failed - showing local copy" >&2
    end
    command task $argv
end
