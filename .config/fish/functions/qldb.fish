# Run a read-only SQL++ query against a cp-couchbase that cbc-db is forwarding (dev, stage, sbx) on localhost:<port>.
# Credentials come from the cp-couchbase-auth secret in the current kube context, which cbc-db switches to, so run it
# against the env cbc-db last forwarded.
function qldb --description 'Query a cbc-db port-forward with cbc-qldb'
    if test (count $argv) -lt 2
        echo "usage: qldb <port> <query>" >&2
        return 1
    end

    set -l user (kubectl get secret --namespace default cp-couchbase-auth -o jsonpath='{.data.username}' | base64 --decode)
    set -l pass (kubectl get secret --namespace default cp-couchbase-auth -o jsonpath='{.data.password}' | base64 --decode)

    cbc-qldb --url http://localhost:$argv[1] --user "$user" --password "$pass" $argv[2..]
end
