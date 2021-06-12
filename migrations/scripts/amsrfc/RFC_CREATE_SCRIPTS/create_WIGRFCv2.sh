#!/bin/bash
region="us-east-1"
filename=$1
wig_vpc=$2
wig_subnet=$3
date=`date +%d-%b-%y`
#for instance in ${InstanceIds//' '/ }
for line in `cat ../../$filename"_instances"`
do
servername=$(echo $line | awk -F ":" '{print $1}')
instance=$(echo $line | awk -F ":" '{print $2}')
instancetype=$(echo $line | awk -F ":" '{print $3}')
PARAMETER_JSON_STRING=$( jq -n \
                  --arg instanceid "$instance" \
                  --arg vpcid "$wig_vpc" \
                  --arg subnet "$wig_subnet" \
                  --arg instancetype "$instancetype" \
                  --arg instancevalidation true \
                  --arg name "$servername" \
                  --arg description "WIGs RFC for $servername" \
                  '{InstanceId: $instanceid, TargetVpcId: $vpcid, TargetSubnetId: $subnet, TargetInstanceType: $instancetype, ApplyInstanceValidation: true, Name: $name, Description: $description}' )

RFC_JSON_STRING=$( jq -n \
                  --arg changetype "ct-257p9zjk14ija" \
                  --arg version "1.0" \
                  --arg title "WIGs RFC for $servername : $instance" \
                  '{ChangeTypeId: $changetype, ChangeTypeVersion: $version, Title: $title}' )

echo $PARAMETER_JSON_STRING > ../RFC_PARAMETERS_JSON/WIGsRFCParams.json
echo $RFC_JSON_STRING > ../RFC_JSONS/WIGsRFC.json

ChangeType="WIGs"
echo "*************************************"
echo "You are going to Create $ChangeType RFC with following details. Review and confirm. "
echo "*************************************"
echo "RFC Details : "
cat ../RFC_JSONS/WIGsRFC.json | jq
echo "*************************************"
echo "RFC Parameters Details : "
echo "*************************************"
cat ../RFC_PARAMETERS_JSON/WIGsRFCParams.json | jq
echo "*************************************"
echo "WIGs RFC to be created for Instance: $instance"
echo "*************************************"

    RFC_ID=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/WIGsRFC.json \
        --execution-parameters file://../RFC_PARAMETERS_JSON/WIGsRFCParams.json --region $region | jq -r .RfcId)

    echo "Created WIGs RFC with ID for $instance: " $RFC_ID
    echo "*******************************************"
    echo "Submitting WIGs RFC for $instance: " $RFC_ID
    echo "Time of Submission: " `date`
    aws amscm submit-rfc --rfc-id $RFC_ID --region $region

done

