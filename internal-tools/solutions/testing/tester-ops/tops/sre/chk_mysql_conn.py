#!/usr/bin/python
# -*- coding: utf-8 -*-

import paramiko
import socket
import sys

# Getting hostname to check mysql status
# h_name = raw_input("Enter server hostname or ipaddress:> ")
h_name = sys.argv[1]


# MySQL service status and MySQL server status
def check_mysql(h_name):
    try:
        print ("Establishing ssh connection")
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(h_name, username='user1', password="password")
        stdin, stdout, stderr = client.exec_command("sudo mysqladmin ping")
        stderr = stderr.read()
        stdout = stdout.read()
        stdo = "mysqld is alive"
        if stdo in stdout:
            print "..................... MySQL is UP on ", h_name, "....................."
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            client.connect(h_name, username='user1', password="password")
            stdin, stdout, stderr = client.exec_command("sudo mysqladmin status")
            print "..................... MySQL status on ",h_name, "....................."
            print stdout.read()
            client.close()
        else:
            print "MySQL is DOWN on", h_name
            sys.exit()
    except paramiko.SSHException, e:
        print "Password is invalid:" , e
    except paramiko.AuthenticationException:
        print "Authentication failed for some reason"
    except socket.error, e:
        print "Socket connection failed:", e
        client.close()

# Run main function 
if __name__ == '__main__':
    check_mysql(h_name)
