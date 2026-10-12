function tsync --description 'Sync Taskwarrior via the taskwarrior-sync git repo'
    set -l repo ~/taskwarrior-sync
    # Pull first so we never sync against a stale copy of the server file.
    if git -C $repo rev-parse -q --verify origin/HEAD >/dev/null 2>&1; or git -C $repo ls-remote --exit-code --heads origin >/dev/null 2>&1
        git -C $repo pull -q --ff-only; or begin
            echo "tsync: pull failed (diverged?) - not syncing" >&2
            return 1
        end
    end
    task sync; or return 1
    git -C $repo add -A
    git -C $repo diff --cached --quiet; and return 0
    git -C $repo commit -qm "sync from "(string split -f1 . $hostname)
    git -C $repo push -q -u origin HEAD
end
