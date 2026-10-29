# Print an "Updated in <commit URL>" PR comment for HEAD; PR number from $argv[1], else $pullnum.
function com
    set -l p "PULLNUM"

    if set -q pullnum
        set p $pullnum
    end

    if test (count $argv) -ge 1
        set p $argv[1]
    end

    echo "Updated in https://github.com/couchbasecloud/couchbase-cloud/pull/$p/commits/$(gcom)"
end
