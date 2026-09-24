# Exports a key/secret/token triple into the AWS_* environment; env creds win over any active
# profile, so the profile is dropped at the same time.
function _awsAssumeAthenaExport
    test (count $argv) -eq 3; or return 1

    set -gx AWS_ACCESS_KEY_ID     $argv[1]
    set -gx AWS_SECRET_ACCESS_KEY $argv[2]
    set -gx AWS_SESSION_TOKEN     $argv[3]

    # `set -e` returns 4 when the variable is already unset, so it cannot be the last
    # command here — callers read this function's status to decide whether the hop worked.
    set -e AWS_PROFILE
    return 0
end

function awsAssumeGuardiansAthena --description 'Assume cbc-billing-athena-local-dev in cb-se via the per-user dbaas-test-0005 role'
    # The console switch-role button cannot reach this role: its trust policy only lists the
    # per-user roles in dbaas-test-0005, so the chain has to be walked in two hops.
    #
    #   IAM user <you> (044057754343) -> role <you> (dbaas-test-0005) [MFA] -> athena role (cb-se)
    set -l test_account 264138468394
    set -l athena_role arn:aws:iam::691383351830:role/cbc-billing-athena-local-dev
    set -l q 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
    set -l session (whoami)-athena

    set -l base_profile $GARDIANS_BASE_PROFILE
    test -z "$base_profile"; and set base_profile cbc-main

    # Inherited creds from an earlier assume would shadow --profile on the first hop.
    set -e AWS_PROFILE AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN AWS_SECURITY_TOKEN

    # The per-user role is named after the IAM user, so ask the main account who we are.
    set -l user (aws iam get-user --profile $base_profile --query User.UserName --output text 2>/dev/null)
    if test -z "$user"; or test "$user" = None
        echo "could not read the IAM user from profile '$base_profile' — are its keys valid?" >&2
        return 1
    end
    set -l user_role "arn:aws:iam::$test_account:role/$user"

    set -l serial (aws iam list-mfa-devices --profile $base_profile \
        --query 'MFADevices[0].SerialNumber' --output text 2>/dev/null)
    if test -z "$serial"; or test "$serial" = None
        echo "no MFA device registered for $user" >&2
        return 1
    end
    read -l -P "MFA code for $serial: " code

    # Hop 1 — this is the hop that needs MFA; the session carries the MFA context into hop 2.
    # fish command-sub splits on newlines, so split the tab-separated creds row ourselves.
    echo "Assuming $user_role from $base_profile ..." >&2
    set -l creds (aws sts assume-role --profile $base_profile --role-arn $user_role \
        --role-session-name $session --serial-number $serial --token-code $code \
        --query $q --output text | string split \t)
    if not _awsAssumeAthenaExport $creds
        echo "assume-role into $user_role failed" >&2
        return 1
    end

    # Hop 2 — role chaining, so AWS caps this session at one hour.
    echo "Assuming $athena_role ..." >&2
    set creds (aws sts assume-role --role-arn $athena_role \
        --role-session-name $session --query $q --output text | string split \t)
    if not _awsAssumeAthenaExport $creds
        echo "assume-role into $athena_role failed" >&2
        return 1
    end

    set -gx AWS_DEFAULT_REGION us-east-1
    echo "Now: "(aws sts get-caller-identity --query Arn --output text)" (expires in 1 hour)" >&2
end
