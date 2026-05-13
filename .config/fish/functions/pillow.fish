function pillow
    echo /opt/couchbase/bin/cbc-pillowfight \
        -U "couchbases://localhost/pillow?ssl=no_verify" \
        -u 'couchbase-cloud-admin' \
        -P "'"(cbc-cluster-admin-password $dbid)"'" \
        --min-size=1024 --max-size=1024 \
        --num-items=20000000 --num-threads=32 \
        --batch-size=500 --populate-only --sequential \
        --key-prefix=genA-
end
