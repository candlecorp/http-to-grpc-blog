#/bin/bash
for i in {0..100000}
do
    #adding some randomness
    rand=$(( $RANDOM % 100 + 1 ))
    if [ $rand -gt 70 ] 
    then
        wafl rpc hostname=envoy invoke --port=8080 hello -- --first_name=Jane --last_name=Doe
    fi
    if [ $rand -lt 5 ] 
    then
        # 5% chance of error
        wafl rpc hostname=envoy invoke --port=8080 greet -- --adfasfasfasdfas=unknown
    fi
    sleep 0.25
done