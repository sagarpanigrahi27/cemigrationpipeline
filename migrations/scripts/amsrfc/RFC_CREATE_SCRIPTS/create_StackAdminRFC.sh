#!/bin/bash
region="us-east-1"
ChangeType="StackAdmin"
echo "*************************************"
echo "You are going to Create $ChangeType RFC with following details. Review and confirm. "
echo "*************************************"
echo "RFC Details : "
cat ../RFC_JSONS/Grant_Stack_Admin.json | jq
echo "*************************************"
echo "RFC Parameters Details : "
echo "*************************************"
#cat ../RFC_PARAMETERS_JSON/GrantStackAdminEC2Param.json | jq
echo "*************************************"
            RFC_ID1=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_CMDMESIUSER-UAT.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID1
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID1
            aws amscm submit-rfc --rfc-id $RFC_ID1 --region $region
sleep 5
            RFC_ID2=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_cmdmuser-nonprod.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID2
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID2
            aws amscm submit-rfc --rfc-id $RFC_ID2 --region $region
sleep 5

            RFC_ID3=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_CMDMUSER-NP.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID3
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID3
            aws amscm submit-rfc --rfc-id $RFC_ID3 --region $region
sleep 5
            RFC_ID4=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_mdmprfadbind.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID4
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID4
            aws amscm submit-rfc --rfc-id $RFC_ID4 --region $region
sleep 5
            RFC_ID5=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_mdmprfasadm.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID5
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID5
            aws amscm submit-rfc --rfc-id $RFC_ID5 --region $region
sleep 5
            RFC_ID6=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_mdmprfctrlm.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID6
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID6
            aws amscm submit-rfc --rfc-id $RFC_ID6 --region $region

sleep 5
            RFC_ID7=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_mdmprfesb.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID7
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID7
            aws amscm submit-rfc --rfc-id $RFC_ID7 --region $region

sleep 5
            RFC_ID8=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_mdmprfmfth.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID8
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID8
            aws amscm submit-rfc --rfc-id $RFC_ID8 --region $region
sleep 5
            RFC_ID9=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_mdmstctrlm.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID9
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID9
            aws amscm submit-rfc --rfc-id $RFC_ID9 --region $region
sleep 5
            RFC_ID10=$(aws amscm create-rfc --cli-input-json file://../RFC_JSONS/Grant_Stack_Admin.json \
                --execution-parameters file://../RFC_PARAMETERS_JSON/GrantStackAdmin_mdmuatctrlm.json --region $region | jq -r .RfcId)

            echo "Created RFC with ID: " $RFC_ID10
            echo "*******************************************"
            echo "Submitting RFC : " $RFC_ID10
            aws amscm submit-rfc --rfc-id $RFC_ID10 --region $region
