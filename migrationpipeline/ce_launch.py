import requests
import jsonpath
import json
import yaml
import sys

base_url = "https://console.cloudendure.com/api/latest"
#SERVERNAME = sys.argv[1]

with open('custom_header.json') as json_file:
    custom_header = json.load(json_file)

with open("current_project_id", "r") as file:
    target_project_id = file.read().replace('\n', '')

machines_file = open("current_machine_ids", "r")

machines_pl = []
launch_pl = {}
for line in machines_file:
    machines_pl.append({'machineId': line.replace('\n', '')})
launch_pl['items'] = machines_pl
launch_pl['launchType'] = 'TEST'
#launch_load = json.dumps(launch_pl)

print (launch_pl)

print (base_url + '/projects/' + target_project_id + '/launchMachines')
try:
    celaunch_req = requests.post( base_url + '/projects/' + target_project_id + '/launchMachines', json = launch_pl, headers = custom_header)
    print (celaunch_req.json())
except:
    print ("Error!!!")
#target_machine_obj = next(item for item in machine_req.json()["items"] if item['sourceProperties']['name'] == SERVERNAME)
#target_machine_id = target_machine_obj['id']
target_job_id = (celaunch_req.json()["id"])
text_file = open("current_job_id", "w")
text_file.write(target_job_id)
text_file.close()

print (celaunch_req)



