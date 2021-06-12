#!/bin/bash
filename=$1
countofserver=`expr $(cat ../../$filename | wc -l)`
echo "Total to be checked: "$countofserver
while [[ $countofcomplete != $countofserver ]]
do
countofcomplete=0
countofsuccess=0
countoffailure=0
for i in `cat ../../$filename`
do
servername=$(echo $i | awk -F ":" '{print $1}')
#echo $servername
rfc_id=$(echo $i | awk -F ":" '{print $2}')
#echo $rfc_id
rfc_status=$(./check_AMSRFC.sh $rfc_id)
if [[ $rfc_status == 'Success' ]]; then
    echo "RFC for "$serveranme "is complete."
    countofsuccess=`expr $countofsuccess + 1`
elif [[ $rfc_status == 'Failure' ]]; then
    countoffailure=`expr $countoffailure + 1`
fi
countofcomplete=`expr $countofsuccess + $countoffailure`
echo "Total Succes:" $countofsuccess
echo "Total Failure:" $countoffailure
done
sleep 60
done
echo "All status checks for RFCs are complete.."
