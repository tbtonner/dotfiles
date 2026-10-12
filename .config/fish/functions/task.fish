function task --wraps task --description 'Taskwarrior; bare `task` kicks off a background sync'
    if test (count $argv) -eq 0
        # Reuse the on-exit hook's detached, debounced, locked sync; the list
        # below is the local copy, anything pulled shows on the next run.
        echo sync | ~/.task/hooks/on-exit-tsync
    end
    command task $argv
end
