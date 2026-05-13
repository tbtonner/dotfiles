# Set UTF-8 locale for tmux and terminal
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -x EDITOR nvim

# vi key bindings
set -g fish_key_bindings fish_vi_key_bindings

# working dir
if test (pwd) = $HOME
    cd /Users/tomtonner/work/couchbase-cloud
end

# paths
fish_add_path /Users/tomtonner/go/bin
fish_add_path /Users/tomtonner/.cargo/bin
fish_add_path /Users/tomtonner/work/server/install/bin
fish_add_path /Users/tomtonner/bin
fish_add_path /Users/tomtonner/.local/share/nvim/mason/bin/
fish_add_path /Users/tomtonner/couchbase-cloud/.bin

# git aliases
alias g='git'
alias gst='git status'
alias gs='git stash'
alias grh='git reset --hard'
alias gsp='git stash pop'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git pull'
alias gql='git ql'
alias gup='git pull --rebase'
alias gp='git push'
alias gc='git commit'
alias gco='git checkout'
alias gg='git gud'
alias ga='git add'
alias gaa='git add .'
alias gac='gaa; gc -m'
alias gacn='gaa; gc --no-verify -m'
alias gcp='git cherry-pick'
alias gcom='git log -1 --pretty=format:"%h" | tr -d "\n"'

# cbclocal aliases
alias cbc='go run ./cmd/cbclocal up --with-services=ui-static,scheduler,open-api,fm-ui-static,fm-gateway'
alias cbclocal='go run ./cmd/cbclocal'
alias cbclu='go run ./cmd/cbclocal up --with-services=ui-static'
alias cbcld='go run ./cmd/cbclocal down'
alias cbcldf='go run ./cmd/cbclocal down --force; docker volume rm cbclocal_db'
alias cbclr='go run ./cmd/cbclocal restart'
alias cbclc='go run ./cmd/cbclocal hosted clusters'

# testing aliases
alias integrationtest='godotenv -f ../local_test.env,local.env go test -tags=integration -count=1'
alias unittest='cat /Users/tomtonner/work/unittest.go | pbcopy'
alias cplint='golangci-lint run --new-from-rev=main --config cv/golangci.yml'

function idcp
    jq '.[].id' -r $argv | pbcopy
end

# jwt
alias jwt='http POST http://localhost:8080/sessions -a tom.tonner@couchbase.com:Password123! | jq -r ".jwt"'
alias jwtMember='http POST http://localhost:8080/sessions -a tom.tonner1@couchbase.com:Password1# | jq -r ".jwt"'
alias jwtProject='http POST http://localhost:8080/sessions -a tom.tonner2@couchbase.com:Password1# | jq -r ".jwt"'

# always use block cursor
set -g fish_cursor_default block
set -g fish_cursor_insert block
set -g fish_cursor_replace_one block
set -g fish_cursor_visual block

# colours (kanagawa)
set kanagawa_black 16161D
set kanagawa_red C34043
set kanagawa_green 76946A
set kanagawa_gold C0A36E
set kanagawa_blue 7E9CD8
set kanagawa_purple 957FB8
set kanagawa_green_blue 6A9589
set kanagawa_sand C8C093
set kanagawa_grey 727169
set kanagawa_light_red  E82424
set kanagawa_light_green 98BB6C
set kanagawa_dark_sand E6C384
set kanagawa_bright_blue 7FB4CA
set kanagawa_dark_purple 938AA9
set kanagawa_teal 7AA89F
set kanagawa_white DCD7BA
set kanagawa_orange FFA066
set kanagawa_bright_red FF5D62

# prompt
set -g theme_display_time yes
set -g theme_display_group no
set -g theme_display_hostname no
set -g theme_display_rw no
set -g theme_display_virtualenv yes

set -g theme_color_time               $kanagawa_sand
set -g theme_color_user               $kanagawa_blue
set -g theme_color_path               $kanagawa_light_green
set -g __fish_git_prompt_color_branch $kanagawa_bright_red

# syntax highlighting
set -g fish_color_normal             normal
set -g fish_color_command            b294bb
set -g fish_color_keyword            normal
set -g fish_color_param              81a2be
set -g fish_color_option
set -g fish_color_quote              b5bd68
set -g fish_color_comment            f0c674
set -g fish_color_error              cc6666
set -g fish_color_end                b294bb
set -g fish_color_operator           00a6b2
set -g fish_color_escape             00a6b2
set -g fish_color_redirection        8abeb7
set -g fish_color_autosuggestion     969896
set -g fish_color_valid_path         --underline
set -g fish_color_match              --background=brblue
set -g fish_color_search_match       bryellow --background=brblack
set -g fish_color_selection          white --bold --background=brblack
set -g fish_color_cancel             --reverse
set -g fish_color_history_current    --bold
set -g fish_color_cwd                green
set -g fish_color_cwd_root           red
set -g fish_color_host               normal
set -g fish_color_user               brgreen
set -g fish_color_status             red
set -g fish_pager_color_prefix       normal --bold --underline
set -g fish_pager_color_completion   normal
set -g fish_pager_color_description  B3A06D
set -g fish_pager_color_progress     brwhite --background=cyan
