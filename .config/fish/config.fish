set fish_cursor_default block

# paths
fish_add_path /Users/tomtonner/go/bin
fish_add_path /Users/tomtonner/.cargo/bin
fish_add_path /Users/tomtonner/work/server/install/bin
fish_add_path /Users/tomtonner/bin
fish_add_path /Users/tomtonner/.local/share/nvim/mason/bin/

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

# git aliases
alias g='git'
alias gst='git status'
alias gs='git stash'
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

# cbclocal aliases
alias cbc='go run ./cmd/cbclocal up --with-services=ui-static,scheduler,open-api,fm-ui-static,fm-gateway'
alias cbclocal='go run ./cmd/cbclocal'
alias cbclu='go run ./cmd/cbclocal up --with-services=ui-static'
alias cbcld='go run ./cmd/cbclocal down'
alias cbcldf='go run ./cmd/cbclocal down --force; docker volume rm cbclocal_db'
alias cbclr='go run ./cmd/cbclocal restart'

# testing aliases
alias integrationtest='godotenv -f ../local_test.env,local.env go test -tags=integration -count=1'
alias unittest='cat /Users/tomtonner/work/unittest.go | pbcopy'

# jwt
alias jwt='http POST http://localhost:8080/sessions -a tom.tonner@couchbase.com:Password123! | jq -r ".jwt"'

# binds
bind \el 'clear; commandline -f repaint'
bind \u00AC 'clear; commandline -f repaint'

# prompt
set -g theme_display_time yes
set -g theme_display_group no
set -g theme_display_hostname no
set -g theme_display_rw no
set -g theme_display_virtualenv yes

set theme_primary                                   88a662 
set theme_secondary                                 e46876 
set theme_primary_variant                           8e79af 
set theme_time                                      6780b1 
set theme_prompt                                    ffffff 
set theme_hilight                                   e4c284 

set -g theme_color_user                             $theme_hilight
set -g theme_color_host                             $theme_primary_variant
set -g theme_color_separator                        brblack
set -g theme_color_normal                           normal
set -g theme_color_time                             $theme_time
set -g theme_color_path                             $theme_primary
set -g theme_color_prompt                           $theme_prompt
set -g theme_color_virtualenv                       $theme_secondary
set -g theme_color_status_prefix                    $theme_hilight
set -g theme_color_status_jobs                      $theme_primary
set -g theme_color_status_rw                        $theme_primary
set -g theme_display_group                          no
set -g theme_prompt_segment_separator_color         $theme_primary
set -g theme_prompt_userhost_separator              '.'
set -g __fish_git_prompt_char_branch_begin          '['
set -g __fish_git_prompt_char_branch_end            ']'
set -g __fish_git_prompt_color_branch_begin         brblack
set -g __fish_git_prompt_color_branch_end           brblack
set -g __fish_git_prompt_color_branch               $theme_secondary
