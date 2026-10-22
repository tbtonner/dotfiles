function dd-log-escape --description 'Escape a string for a Datadog log search (port of github.com/jamesl33/dd-log-escape)'
    if test (count $argv) -ne 1
        echo 'Usage: dd-log-escape <string>' >&2
        return 1
    end
    # https://docs.datadoghq.com/logs/explorer/search_syntax/#escape-special-characters-and-spaces
    string replace -ra -- '(&&|\|\||[-+=><!(){}\[\]^"“”~*?:\\\\# ])' '\\\\$1' $argv[1]
end
