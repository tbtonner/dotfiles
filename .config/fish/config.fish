# Set UTF-8 locale for tmux and terminal
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

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
fish_add_path /Users/tomtonner/work/couchbase-cloud/.bin

# functions
function awsAssumeGuardians 
    cbc-aws-assumerole -account dbaas-test-0005 -profile cbc-main -duration 43200
    export AWS_PROFILE=dbaas-test-0005-temp
    export AWS_DEFAULT_REGION=us-east-1
end

function awsAssumeGuardiansStage
    cbc-aws-assumerole -account dbaas-stage-0001 -profile cbc-main
    export AWS_PROFILE=dbaas-stage-0001-temp
    export AWS_DEFAULT_REGION=us-east-1
end

function dd-log-star
    dd-log-escape $argv[1] | sed -E 's/%[a-zA-Z0-9]/*/g' | pbcopy
end

function com
    set -l p "PULLNUM"

    if set -q pullnum
        set p $pullnum
    end

    if test (count $argv) -ge 1
        set p $argv[1]
    end

    echo "Updated in https://github.com/couchbasecloud/couchbase-cloud/pull/$p/commits/$(gcom)"
end

function rgsed
    if test (count $argv) -ne 2
        echo "Usage: rgsed <original> <replacement>"
        return 1
    end

    set original $argv[1]
    set replacement $argv[2]

    for file in (rg -l -- "$original")
        # macOS sed needs '' for -i option
        sed -i '' "s/$original/$replacement/g" "$file"
    end
end

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
alias gd='git diff'
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

# vpn
alias vpn='sudo ~/work/couchbase-cloud/scripts/cbc-setup-vpn.sh'

# testing aliases
alias integrationtest='godotenv -f ../local_test.env,local.env go test -tags=integration -count=1'
alias unittest='cat /Users/tomtonner/work/unittest.go | pbcopy'

# jwt
alias jwt='http POST http://localhost:8080/sessions -a tom.tonner@couchbase.com:Password123! | jq -r ".jwt"'

# binds
bind \u00AC 'clear; commandline -f repaint'
bind -M insert \u00AC 'clear; commandline -f repaint'

# always use block cursor
set -g fish_cursor_default block
set -g fish_cursor_insert block
set -g fish_cursor_replace_one block
set -g fish_cursor_visual block

# prompt
set -g theme_display_time yes
set -g theme_display_group no
set -g theme_display_hostname no
set -g theme_display_rw no
set -g theme_display_virtualenv yes

set kanagawa_green  76946A
set kanagawa_red    C34043
set kanagawa_purple 958FB8
set kanagawa_gold   C0A36E

set -g theme_color_time               $kanagawa_purple
set -g theme_color_user               $kanagawa_gold
set -g theme_color_path               $kanagawa_green
set -g __fish_git_prompt_color_branch $kanagawa_red
