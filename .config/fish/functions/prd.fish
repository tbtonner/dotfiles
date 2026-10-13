function prd --description 'Show a GitHub PR diff through delta (PR number/URL/branch; default: current branch)'
    # extra args (e.g. --name-only) go to gh pr diff
    gh pr diff --color=never $argv | delta
end
