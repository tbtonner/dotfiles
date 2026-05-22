function unjson --description 'Unescape a JSON string with backslash-escaped quotes'
    if test (count $argv) -gt 0
        echo $argv | string replace -a '\\"' '"'
    else
        read -z | string replace -a '\\"' '"'
    end
end
