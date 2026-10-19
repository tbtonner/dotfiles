function cbcl --description "Run cbclocal with its JSON logs pretty-printed through hl"
    # Logs go to stdout or stderr depending on the logger config, and `go run` build errors go to stderr, so merge
    # both. hl passes non-JSON lines through untouched; -P streams live instead of buffering into a pager.
    go run ./cmd/cbclocal $argv &| hl -P
    # Return cbclocal's exit status, not hl's.
    return $pipestatus[1]
end
