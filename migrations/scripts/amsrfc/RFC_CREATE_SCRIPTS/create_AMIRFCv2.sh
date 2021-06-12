#!/bin/bash
region="us-east-1"
#read -p 'Enter EC2 Instance ID(s) to create AMI (separate by comma for multiple values): ' InstanceIds
AMItype=$1
filename=$2
date=`date +%d-%b-%Y-%I-%M-%p`
#for instance in ${InstanceIds//' '/ }
for line in `cat ../../$filename"_instances"`
do
servername=$(echo $line | awk -F ":" '{print $1}')
instance=$(echo $line | awk -F ":" '{print $2}')
JSON_STRING=$( jq -n \
                  --arg instanceid "$instance" \
                  --arg aminame "$servername"-"$AMItype"-ami-"$date" \
                  --arg tags "$TAG_JSON" \
                  --arg key "Name" \
                  --arg value "$servername" \
                  '{AmiName: $aminame, InstanceId: $instanceid, AmiTags: [{Key: $key, Value: $value }]}' )
sudo echo $JSON_STRING > ../RFC_PARAMETERS_JSON/AMICreateRFCParams.json

RFC_JSON_STRING=$( jq -n \
                  --arg changetype "ct-3rqqu43krekby" \
                  --arg version "2.0" \
                  --arg title "Create $AMItype RFC for $servername : $instance" \
                  '{ChangeTypeId: $changetype, ChangeTypeVersion: $version, Title: $title}' )

sudo echo $RFC_JSON_STRING > ../RFC_JSONS/AMICreateRFC.json

ChangeType="AMICreate"
echo "*************************************"
echo "You are going to Create $ChangeType RFC with following details. Review and confirm. "
echo "*************************************"
echo "RFC Details : "
 cat ../RFC_JSONS/AMICreateRFC.json | jq
echo "*************************************"
echo "RFC Parameters Details : "
echo "*************************************"
cat ../RFC_PARAMETERS_JSON/AMICreateRFCParams.json | jq
echo "*************************************"
echo "AMI To be created for Instance: $instance"
echo "*************************************"
RFC_ID=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/AMICreateRFC.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/AMICreateRFCParams.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID for $instance: " $RFC_ID
            echo "*******************************************"
            echo "Submitting RFC for $instance: " $RFC_ID
            aws amscm submit-rfc --rfc-id $RFC_ID --region $region
sudo echo $servername":"$RFC_ID >> ../../rfc_list.txt
done

