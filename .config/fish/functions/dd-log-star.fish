function dd-log-star
    dd-log-escape $argv[1] | sed -E 's/%[a-zA-Z0-9]/*/g' | pbcopy
end
