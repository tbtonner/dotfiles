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
    __tsync_compact_ids
    git -C $repo add -A
    git -C $repo diff --cached --quiet; and return 0
    git -C $repo commit -qm "sync from "(string split -f1 . $hostname)
    git -C $repo push -q -u origin HEAD
end

# `task sync` rebuilds the working set without renumbering, and taskchampion never closes a gap once it exists, so IDs
# drift upwards. Close the gaps here; the working set is local only and never synced.
function __tsync_compact_ids
    command -q sqlite3; or begin
        echo "tsync: sqlite3 not installed - task IDs not compacted" >&2
        return 0
    end
    set -l db (task _get rc.data.location)/taskchampion.sqlite3
    sqlite3 $db 'BEGIN; CREATE TEMP TABLE ws AS SELECT row_number() OVER (ORDER BY id) AS id, uuid FROM working_set; DELETE FROM working_set; INSERT INTO working_set SELECT id, uuid FROM ws; COMMIT;'
end
