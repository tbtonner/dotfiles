function rgsed
    if test (count $argv) -ne 2
        echo "Usage: rgsed <original> <replacement>"
        return 1
    end

    set original $argv[1]
    set replacement $argv[2]

    for file in (rg -l -- "$original")
        sed -i '' "s/$original/$replacement/g" "$file"
    end
end
