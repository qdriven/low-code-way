# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     ansible_hosts_generator
   Description :
   Author :        patrick
   date：          2019/10/10
-------------------------------------------------
   Change Activity:
                   2019/10/10:
-------------------------------------------------
"""
import json

__author__ = 'patrick'

HOST_TEMP = "{prefix}-{index} ansible_host={ip} ansible_ssh_user={user} ansible_ssh_pass={pwd}"
HOST_TEMP_PRIVATE = "{prefix}-{index} ansible_host={ip} ansible_ssh_user={user} ansible_ssh_private_key_file=~/.ssh/id_rsa "


def generate_ansible_hosts(prefix, ip_prefix,
                           ip_start, num, user, pwd):
    for index in range(num):
        host_str = HOST_TEMP.format(prefix=prefix,
                                    index=index + 1, ip=str(ip_prefix) + "." + str(ip_start + index),
                                    user=user,
                                    pwd=pwd
                                    )
        print(host_str)


def generate_ansible_hosts_by_json(prefix, json_file="nodes.json"):
    with open(json_file,'rb') as nodes:
        nodes_raw = json.load(nodes)
        nodes_conf = nodes_raw["NODES"]
    for index in range(len(nodes_conf)):
        HOST_TEMP_PRIVATE_STR = HOST_TEMP_PRIVATE.format(prefix=prefix,
            index=index+1,ip=str(nodes_conf[index]["ip"]),user="ubuntu"
        )
        print(HOST_TEMP_PRIVATE_STR)
    for index in range(len(nodes_conf)):
        print("\"{}:20338\",".format(nodes_conf[index]["ip"]))


if __name__ == '__main__':
    # generate_ansible_hosts("cc", "172.168.3", 141, 7, "ubuntu", "ubuntu")
    generate_ansible_hosts_by_json("main")
