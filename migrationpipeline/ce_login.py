import requests
import jsonpath
import json
import yaml
import sys

print ("Total arguments passed:", len(sys.argv))
SERVERNAME = sys.argv[1]
CETOKEN = sys.argv[2]
CEPROJECT = sys.argv[3]

base_url = "https://console.cloudendure.com/api/latest"
pload = { 'userApiToken': CETOKEN }
login_req = requests.post( base_url + '/login', json = pload)
#XSRF_TOKEN =
custom_header = { 'Cookie':login_req.headers['Set-Cookie'].replace(' Secure; Path=/, ',''),'X-XSRF-TOKEN': login_req.headers['Set-Cookie'].split(";")[0].split("XSRF-TOKEN=")[1].strip('"')}
#print (custom_header)

with open('custom_header.json', 'w') as f:
    json.dump(custom_header, f)


with open("variables.yaml", 'r') as stream:
    try:
        variable_data = next(item for item in yaml.safe_load(stream)["servers"] if item['name'] == SERVERNAME)
        #print(variable_data)
    except yaml.YAMLError as exc:
        print(exc)
    except StopIteration:
        pass


project_req = requests.get( base_url + '/projects', headers = custom_header)
try:
    target_project_obj = next(item for item in project_req.json()["items"] if item['name'] == CEPROJECT)
except StopIteration:
    pass

target_project_id = target_project_obj['id']

text_file = open("current_project_id", "w+")
text_file.write(target_project_id)
text_file.close()

machine_req = requests.get( base_url + '/projects/' + target_project_id + '/machines', headers = custom_header)
try:
    target_machine_obj = next(item for item in machine_req.json()["items"] if item['sourceProperties']['name'] == SERVERNAME)
except StopIteration:
    pass
target_machine_id = target_machine_obj['id']

text_file = open("current_machine_ids", "a+")
text_file.write(target_machine_id + '\r\n')
text_file.close()


individual_machine_req = requests.get( base_url + '/projects/' + target_project_id + '/machines/' + target_machine_id, headers = custom_header)
target_machine_os = individual_machine_req.json()['sourceProperties']['os']

text_file = open("platform_info", "a+")
text_file.write(SERVERNAME + ":" + target_machine_os + '\r\n')
text_file.close()



blueprint_req = requests.get( base_url + '/projects/' + target_project_id + '/blueprints', headers = custom_header)
try:
    target_blueprint_obj = next(item for item in blueprint_req.json()["items"] if item['machineId'] == target_machine_id)
except StopIteration:
    pass
target_blueprint_id = target_blueprint_obj['id']

for item in target_blueprint_obj['disks']:
        item["type"] = "SSD"

if 'existinginstanceid' in variable_data:
    try:
        target_blueprint_obj['launchOnInstanceId'] = variable_data['existinginstanceid']
        target_blueprint_obj.pop('iamRole')
        target_blueprint_obj.pop('recommendedInstanceType')
        target_blueprint_obj.pop('publicIPAction')
        target_blueprint_obj.pop('securityGroupIDs')
        target_blueprint_obj.pop('recommendedPrivateIP')
        target_blueprint_obj.pop('instanceType')
        target_blueprint_obj.pop('networkInterface')
        target_blueprint_obj.pop('staticIp')
        target_blueprint_obj.pop('tags')
        target_blueprint_obj.pop('privateIPs')
        target_blueprint_obj.pop('tenancy')
        target_blueprint_obj.pop('subnetsHostProject')
        target_blueprint_obj.pop('byolOnDedicatedInstance')
        target_blueprint_obj.pop('placementGroup')
        target_blueprint_obj.pop('privateIPAction')
        target_blueprint_obj.pop('staticIpAction')
        target_blueprint_obj.pop('subnetIDs')
        target_blueprint_obj.pop('region')
#        target_blueprint_obj.pop('dedicatedHostIdentifier')
        target_blueprint_obj.pop('forceUEFI')
    except KeyError:
        print ("Some keys were not found..")
else:
    target_blueprint_obj.pop('forceUEFI')
    target_blueprint_obj.pop('byolOnDedicatedInstance')
    target_blueprint_obj['iamRole'] = variable_data['iamrole']
    target_blueprint_obj['subnetIDs'] = variable_data['subnet']
    target_blueprint_obj['privateIPAction'] = 'CREATE_NEW'
    target_blueprint_obj['publicIPAction'] = 'AS_SUBNET'
    target_blueprint_obj['tags'] = variable_data['tags']
    target_blueprint_obj['securityGroupIDs'] = variable_data['securitygroups']
    target_blueprint_obj['instanceType'] = variable_data['instancetype']


json.dumps(target_blueprint_obj)


blueprint_req = requests.patch( base_url + '/projects/' + target_project_id + '/blueprints/' + target_blueprint_id, headers =custom_header, json = target_blueprint_obj)
print(blueprint_req)

