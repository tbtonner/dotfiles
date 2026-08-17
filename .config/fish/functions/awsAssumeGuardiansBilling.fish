function awsAssumeGuardiansBilling --description 'Assume cbc-it-billing role in a Couchbase master-payer account'
    # Target MPA — defaults to couchbasecloudmpa001 (dev/test master payer)
    set -l account $argv[1]
    test -z "$account"; and set account 607212519036

    # cbc-main = your IAM user in 044057754343, which is trusted to assume cbc-it-billing
    set -l base_profile $GARDIANS_BASE_PROFILE
    test -z "$base_profile"; and set base_profile cbc-main

    set -l role_arn "arn:aws:iam::$account:role/cbc-it-billing"
    set -l session (whoami)-billing
    echo "Assuming $role_arn from $base_profile ..." >&2

    # fish command-sub splits on newlines, so split the tab-separated creds row ourselves
    set -l q 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken]'
    set -l creds (aws sts assume-role --profile $base_profile --role-arn $role_arn \
        --role-session-name $session --query $q --output text 2>/dev/null | string split \t)

    # retry with MFA if the role requires it
    if test (count $creds) -ne 3
        set -l serial (aws iam list-mfa-devices --profile $base_profile \
            --query 'MFADevices[0].SerialNumber' --output text)
        read -l -P "MFA code for $serial: " code
        set creds (aws sts assume-role --profile $base_profile --role-arn $role_arn \
            --role-session-name $session --serial-number $serial --token-code $code \
            --query $q --output text | string split \t)
    end

    if test (count $creds) -ne 3
        echo "assume-role into cbc-it-billing failed" >&2
        return 1
    end

    set -gx AWS_ACCESS_KEY_ID     $creds[1]
    set -gx AWS_SECRET_ACCESS_KEY $creds[2]
    set -gx AWS_SESSION_TOKEN     $creds[3]
    set -e AWS_PROFILE  # env creds win over any active profile

    echo "Now: "(aws sts get-caller-identity --query Arn --output text) >&2
end
