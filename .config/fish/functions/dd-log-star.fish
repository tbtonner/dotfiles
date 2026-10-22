function dd-log-star --description 'Escape a Go format string for a Datadog log search, with %verbs and * as wildcards, and copy it'
    if test (count $argv) -ne 1
        echo 'Usage: dd-log-star <string>' >&2
        return 1
    end
    # Park Go fmt verbs (%s, %w, %+v, %-8.3f...) and literal * on a placeholder so the escaping leaves them alone
    set -l placeholder \x1f
    set -l str (string replace -ra -- '%[-+# 0-9.*\[\]]*[a-zA-Z]|\*' $placeholder $argv[1] | string collect)
    set -l query (dd-log-escape $str | string replace -a -- $placeholder '*' | string collect)
    printf '%s' $query | pbcopy
    echo $query
end
