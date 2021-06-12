import requests
import jsonpath
import json
import yaml
import sys
import time

base_url = "https://console.cloudendure.com/api/latest"
#SERVERNAME = sys.argv[1]

with open('custom_header.json') as json_file:
    custom_header = json.load(json_file)

with open("current_project_id", "r") as file:
    target_project_id = file.read().replace('\n', '')

with open("current_job_id", "r") as file:
    target_job_id = file.read().replace('\n', '')



job_current_status = "STARTED"
while ( job_current_status != "COMPLETED" ):
    jobstatus_req = requests.get( base_url + '/projects/'+ target_project_id + '/jobs/'+ target_job_id, headers = custom_header)
    job_current_status = (jobstatus_req.json()["status"])
    if ( job_current_status == "FAILED" ):
        print("Job Status: " +job_current_status)
        job_current_status = "COMPLETED"
    print(jobstatus_req.json()["log"][-1]["message"])
    time.sleep(10)



