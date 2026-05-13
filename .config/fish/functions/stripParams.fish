function stripParams
    set url (string collect -- $argv)

    if not string match -q '*?*' -- $url
        return 0
    end

    set query (string split '?' -- $url)[2]

    for pair in (string split '&' -- $query)
        set kv (string split '=' -- $pair)

        if test (count $kv) -eq 2
            set -g $kv[1] $kv[2]
        end
    end
end
