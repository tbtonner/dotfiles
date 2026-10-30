# Run a read-only SQL++ query against supportal (the prod XDCR copy) via couchbase-cloud's cbc-qldb.
function supportal --description 'Query supportal with cbc-qldb'
    cbc-qldb --url "$SUPPORTAL_URL" --user "$SUPPORTAL_DB_USER" --password "$SUPPORTAL_DB_PASS" $argv
end
