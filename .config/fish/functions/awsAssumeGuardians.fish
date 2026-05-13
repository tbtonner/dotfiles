function awsAssumeGuardians
    cbc-aws-assumerole -account dbaas-test-0005 -profile cbc-main -duration 43200
    export AWS_PROFILE=dbaas-test-0005-temp
    export AWS_DEFAULT_REGION=us-east-1
end
