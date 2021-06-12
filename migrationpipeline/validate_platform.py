import requests
import jsonpath
import json
import yaml
import sys

def check_os(file_name, string_to_search):
    """ Check if any line in the file contains given string """
    # Open the file in read only mode
    with open(file_name, 'r') as read_obj:
        # Read all lines in the file one by one
        for line in read_obj:
            # For each line, check if line contains the string
            if string_to_search in line:
                return True
    return False

def print_a_file(file_name):
    with open(file_name, 'r') as read_obj:
        # Read all lines in the file one by one
        for line in read_obj:
            print (line)

windows = False
linux = False

windows = check_os('platform_info','Windows')
linux = check_os('platform_info','Linux')

if windows and linux:
    print("The list of servers contains a mix of Linux and Windows. Please input either linux or windows in one go..")
    print_a_file('platform_info')

