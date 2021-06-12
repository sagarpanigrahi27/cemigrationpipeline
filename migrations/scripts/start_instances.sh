#!/bin/bash
read -p 'Enter the file names in ../../migrations folder (e.g. hpphase2): ' filename
if [ ! -f $filename"_instances" ]; then
echo $filename"_instances file does not exist !!!"
exit 0
fi


echo 'Do you want to start all servers in the list (yes or no ) ?'
select yn in "Yes" "No";do
case $yn in

        "Yes")

                instances=""
                for line in `cat $filename"_instances"`
                do

                        instance=$(echo $line | awk -F ":" '{print $2}')
                        instances=$instances" "$instance
                done
                echo "Starting the following instances: "
                echo "================================"
                echo $instances
                aws ec2 start-instances --instance-ids $instances


                declare -i countofrunning
                countofserver=`expr $(cat $filename"_instances" | wc -l)`
                countofrunning=0
                while [ $countofrunning != $countofserver ]
                do
                countofrunning=0
                for line in `cat $filename"_instances"`
                do
                        instance=$(echo $line | awk -F ":" '{print $2}')
                        state=$(aws ec2 describe-instances --instance-id $instance | jq -r .Reservations[].Instances[].State.Name)
                        instance_status=$(aws ec2 describe-instance-status --instance-id $instance | jq -r .InstanceStatuses[].InstanceStatus.Details[].Status)
                        system_status=$(aws ec2 describe-instance-status --instance-id $instance | jq -r .InstanceStatuses[].SystemStatus.Details[].Status)
                        #echo "State of "$line": "$state

                        if [[ $state == "running" && $system_status == "passed" && $instance_status == "passed" ]];then
                                countofrunning=`expr $countofrunning + 1`
                        fi
                echo -ne ".."
                done
                echo -ne "Total "$countofrunning" started out of "$countofserver"..."
                sleep 5
                done
                echo "All Servers seems to have started.. and Initial 2/2 status checks passed.."
                break
                ;;
        "No")
            read -p "Enter the servername(s) in space separated format to start: " servers
            instances=""
            for server in ${servers//' '/ }
            do
                instance=$(cat  $filename"_instances" | grep $server | awk -F ":" '{print $2}')
                instances=$instances" "$instance

            done
            echo "Starting the following instances: "
                echo "================================"
                echo $instances
                aws ec2 start-instances --instance-ids $instances


                declare -i countofrunning
                countofserver=`expr $(echo ${servers//' '/ } | wc -w)`
                countofrunning=0
                while [ $countofrunning != $countofserver ]
                do
                countofrunning=0
                for server in ${servers//' '/ }
                do
                        instance=$(cat  $filename"_instances" | grep $server | awk -F ":" '{print $2}')
                        state=$(aws ec2 describe-instances --instance-id $instance | jq -r .Reservations[].Instances[].State.Name)
                        instance_status=$(aws ec2 describe-instance-status --instance-id $instance | jq -r .InstanceStatuses[].InstanceStatus.Details[].Status)
                        system_status=$(aws ec2 describe-instance-status --instance-id $instance | jq -r .InstanceStatuses[].SystemStatus.Details[].Status)
                        #echo "State of "$line": "$state

                        if [[ $state == "running" && $system_status == "passed" && $instance_status == "passed" ]];then
                                countofrunning=`expr $countofrunning + 1`
                        fi
                echo -ne ".."
                done
                echo -ne "Total "$countofrunning" started out of "$countofserver"..."
                sleep 5
                done
                echo "All Servers seems to have started.. and Initial 2/2 status checks passed.."
            break
            ;;
        *)
            echo "Enter Only # of option (1 or 2 or 3 ..) as a response.. "
            ;;
    esac
done
