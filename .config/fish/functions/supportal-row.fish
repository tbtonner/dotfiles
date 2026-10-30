# Run a read-only SQL++ query against supportal (the prod XDCR copy) and print the first row, via cbc-qldb-row.
function supportal-row --description 'Query supportal for a single row with cbc-qldb-row'
    cbc-qldb-row --url "$SUPPORTAL_URL" --user "$SUPPORTAL_DB_USER" --password "$SUPPORTAL_DB_PASS" $argv
end
