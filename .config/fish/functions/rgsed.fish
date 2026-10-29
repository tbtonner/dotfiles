# Replace <original> with <replacement> in every file rg finds it in, skipping go.* files (go.mod, go.sum).
function rgsed
    if test (count $argv) -ne 2
        echo "Usage: rgsed <original> <replacement>"
        return 1
    end

    set original $argv[1]
    set replacement $argv[2]

    for file in (rg -l --glob '!go.*' -- "$original")
        # -i.bak works on both BSD (macOS) and GNU sed; `-i ''` is BSD-only
        sed -i.rgsed-bak "s|$original|$replacement|g" "$file"; and rm -f "$file.rgsed-bak"
    end
end
