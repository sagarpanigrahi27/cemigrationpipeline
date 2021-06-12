#!/bin/bash
export AWS_DEFAULT_REGION=us-east-1
#read -p 'Enter the file names in ../../migrations folder (e.g. hpphase2): ' filename
filename=$1
platform=$2

if [ -f $filename"_instances" ]; then
        rm -f $filename"_instances"
        rm -f $filename"_ansible" 2>&1
fi
echo "["$filename"]" > $filename"_ansible"
for i in `cat $filename`
do
        instanceid=$(aws ec2 describe-instances \
                --filters "Name=tag-value,Values=$i" "Name=instance-state-name,Values=running" \
                --query "Reservations[*].Instances[*].InstanceId" --output text)

        instancetype=$(aws ec2 describe-instances \
                --filters "Name=tag-value,Values=$i" "Name=instance-state-name,Values=running" \
                --query "Reservations[*].Instances[*].InstanceType" --output text)

        if [ "$instanceid" != '' ];
        then
        echo $i":"$instanceid":"$instancetype >> $filename"_instances"

        # echo $i":"$(aws ec2 describe-instances \
        #       --filters "Name=tag-value,Values=$i" \
        #       --query "Reservations[*].Instances[*].InstanceId" --output text) >> $filename"_instances"


        echo -e $i" \t ansible_host="$(aws ec2 describe-instances \
                --filters "Name=tag-value,Values=$i" "Name=instance-state-name,Values=running" \
                --query "Reservations[*].Instances[*].PrivateIpAddress" --output text) >> $filename"_ansible"
        fi


done
if [[ "$platform" == "windows" ]]; then
    echo "[all:vars]" >> $filename"_ansible"
    echo "ansible_user=CloudXMigration" >> $filename"_ansible"
    echo "ansible_connection=winrm" >> $filename"_ansible"
    echo "ansible_winrm_server_cert_validation=ignore" >> $filename"_ansible"
elif [[ "$platform" == "linux" ]]; then
    echo "[all:vars]" >> $filename"_ansible"
    echo "ansible_ssh_user=cloudxmigration" >> $filename"_ansible"
    echo "ansible_ssh_extra_args='-o StrictHostKeyChecking=no'" >> $filename"_ansible"
    echo "ansible_connection=ssh" >> $filename"_ansible"
fi


if [ -s $filename"_instances" ]; then
        echo "Following Instance IDs were retrieved:"
        echo "====================================="
        cat $filename"_instances"
        echo "====================================="
        echo "The following host group can be used in the ansible hostfile"
        cat $filename"_ansible"
else
        echo "Nothing could be retrieved !!!"
fi
