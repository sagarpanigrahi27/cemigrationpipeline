#!/bin/bash
region="us-east-1"
if [ "$1" != '' ];
then
    rfc_id=$1
    echo >&2 "Checking Status for RFC ID : "$rfc_id
    status=$(aws amscm get-rfc --rfc-id ${rfc_id} --region $region | jq -r .Rfc.Status.Id)
    echo $status

else
    echo "Pass the RFC ID as parameter!!"
fi
