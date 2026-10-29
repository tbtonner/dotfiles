# Assume a role in dbaas-stage-0001 via cbc-aws-assumerole and switch to its temp profile.
function awsAssumeGuardiansStage
    cbc-aws-assumerole -account dbaas-stage-0001 -profile cbc-main
    export AWS_PROFILE=dbaas-stage-0001-temp
    export AWS_DEFAULT_REGION=us-east-1
end
