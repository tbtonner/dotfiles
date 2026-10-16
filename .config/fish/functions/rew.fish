function rew --description 'Copy a Slack review request for a PR (current branch, or pass a PR number/URL)'
    set -l url (gh pr view $argv --json url --jq .url)
    or return 1
    set -l msg "Hi team :wave: can I get a review on this PR? Thanks in advance :thankyou: $url"
    printf '%s' $msg | /mnt/c/Windows/System32/clip.exe
    echo $msg
end
