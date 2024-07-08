set fish_cursor_default block

# Paths
fish_add_path /Users/tomtonner/go/bin
fish_add_path /Users/tomtonner/.cargo/bin
fish_add_path /Users/tomtonner/work/server/install/bin

# Functions
function awsAssumeGuardians 
	cbc-aws-assumerole -account dbaas-test-0005 -profile cbc-main -duration 43200
    export AWS_PROFILE=dbaas-test-0005-temp
end

# Aliases
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

# task
alias t='task'
alias tl='task list'
alias ta='task add'
alias td='task done'
alias tc='task modify'

alias dotdrop='~/dotfiles/dotdrop.sh --cfg=~/dotfiles/config.yaml'

# cbclocal aliases
alias cbclu='cbclocal up --with-services=ui,scheduler'
alias cbcbilling='awslocal s3 mb s3://billing; cbimport json -c localhost -u 'Administrator' -p 'password' -b cpapi -d file:///Users/tomtonner/work/rates.json -f lines -g %id%; cbimport json -c localhost -u 'Administrator' -p 'password' -b cpapi -d file:///Users/tomtonner/work/factors.json -f lines -g %id%'
alias cbcld='cbclocal down'
alias cbclr='cbclocal restart'

# cp db access
alias assumeStage='go run scripts/cbc-aws-assumerole/main.go -profile cbc-main-account dbaas-stage-0001'
alias cpdev='AWS_PROFILE=dbaas-stage-0001-temp aws eks update-kubeconfig --alias dev-cp --name dev-201909301908-cp-eks --region us-east-1; AWS_PROFILE=dbaas-stage-0001-temp kubectl get secret --namespace default cp-couchbase-auth -o go-template=`{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}`; AWS_PROFILE=dbaas-stage-0001-temp kubectl get pod --selector=app=couchbase; AWS_PROFILE=dbaas-stage-0001-temp kubectl port-forward cp-couchbase-0104 8091:8091'

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

bind \el 'clear; commandline -f repaint'
