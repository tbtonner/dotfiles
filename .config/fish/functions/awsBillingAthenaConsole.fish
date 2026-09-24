# Locate scripts/aws-billing-athena-console.sh: prefer the checkout we are standing in, then
# $CBC_REPO, then the usual clone location.
function _awsBillingAthenaConsoleScript
    set -l candidates (git rev-parse --show-toplevel 2>/dev/null) $CBC_REPO $HOME/work/couchbase-cloud

    for repo in $candidates
        set -l script $repo/scripts/aws-billing-athena-console.sh
        test -f $script; and echo $script; and return 0
    end

    return 1
end

function awsBillingAthenaConsole --description 'Open an AWS console sign-in URL for the billing Athena role in the browser'
    set -l script (_awsBillingAthenaConsoleScript)
    if test -z "$script"
        echo "aws-billing-athena-console.sh not found — set CBC_REPO to your couchbase-cloud checkout" >&2
        return 1
    end

    # --help prints usage on stdout, so let it through untouched rather than trying to open it.
    if contains -- --help $argv; or contains -- -h $argv
        bash $script --help
        return $status
    end

    # The script keeps its progress output and MFA prompt on stderr, so stdout is the URL alone.
    # Extra args (--region, --destination, --profile, --mfa) pass straight through.
    set -l url (bash $script $argv | tail -n 1)
    if not string match -qr '^https://signin\.aws\.amazon\.com/' -- "$url"
        echo "no sign-in URL was produced" >&2
        return 1
    end

    echo $url
    echo "Opening in your default browser — federated sign-in replaces any AWS console session you already have." >&2
    open $url
end
