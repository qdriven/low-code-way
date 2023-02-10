#!/usr/bin/env python

# Create an user on multiple hosts with password, shell, gecos
# Remove an user on multiple hosts

import crypt
import os
import sys
import paramiko
import socket

## print it needs root user privilege to run this script
uid = os.getuid()

if uid != 0:
    print "You need to be a root user to run this script."
    sys.exit()

# Receiving user input
cr_user = 1
rm_user = 2

user_inp = raw_input("Enter 1 to create an User, Enter 2 to remove an User:> ")
m_h_name= raw_input("Enter file name with absolute path which contains hostnames to create a user:> ")
o_name = raw_input("Enter Owner name (==> Just give ENTER when you want to remove an user with option 2 <==):> ")

# Check ssh connection
def check_ssh():
    if user_inp == "1":
        print "Check SSH connection"
        # Check ssh conection
        with open(m_h_name, 'r') as inp:
            for h_name in inp.readlines():
                try:
                    print ("Establishing ssh connection")
                    client = paramiko.SSHClient()
                    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                    client.connect(h_name,username='root')
                    stdin, stdout, stderr = client.exec_command("uptime")
                    print "Server is up and running"
                    print stdout.read()
                except paramiko.SSHException, e:
                    print "Password is invalid:" , e
                except paramiko.AuthenticationException:
                    print "Authentication failed for some reason"
                except socket.error, e:
                    print "Socket connection failed:", e
                client.close()

# Define functint to create an user
def create_user(o_name):
    # Get user inputs to create an user
    if o_name == "owner" or o_name == "OWNER" or o_name == "Owner":
        # Get an employee ID for an user
        emp_id = raw_input("Enter an Employee ID: ")
        print emp_id

        # Get user name
        u_name = raw_input("Enter User name to create: ")
        print u_name

        # Get password
        p_word = raw_input("Enter password: ")
        encrpass = crypt.crypt(p_word,"md5")

        # Get first name of user
        f_name = raw_input("Enter First name of User: ")
        print f_name

        # Get last name of user
        l_name = raw_input("Enter Last name of User: ")
        print l_name

        # Add user with provided input
        owner_gecos = "123/IN"+"/"+emp_id+"/"+f_name+"."+l_name
        u_home = "/home/"+u_name
        sh_bash = "/bin/bash"
        # Iterate over hosts list and check ssh connection and create an user
        with open(m_h_name, 'r') as inp:
            for h_name in inp:
                print h_name
                try:
                    print ("Establishing ssh connection")
                    client = paramiko.SSHClient()
                    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                    client.connect(h_name,username='root')
                    stdin, stdout, stderr = client.exec_command("uptime")
                    print "Server is up and running"
                    print stdout.read()
                    stdin, stdout, stderr = client.exec_command("useradd -d %s -m -c %s -p %s -s %s %s" % (u_home, owner_gecos, encrpass, sh_bash, u_name))
                    print u_name,"is created on",h_name
                except paramiko.SSHException, e:
                    print "Password is invalid:" , e
                except paramiko.AuthenticationException:
                    print "Authentication failed for some reason"
                except socket.error, e:
                    print "Socket connection failed:", e
                client.close()

    # To create SCH user
    if o_name == "owner1" or o_name == "OWNER1" or o_name == "Owner1":
        # Get user name
        u_name = raw_input("Enter User name to create: ")
        print u_name

        # Get password
        p_word = raw_input("Enter password: ")
        encrpass = crypt.crypt(p_word,"md5")

        # Get first name of user
        f_name = raw_input("Enter First name of User: ")
        print f_name

        # Get last name of user
        l_name = raw_input("Enter Last name of User: ")
        print l_name

        # Add user with provided input
        c_gecos = "NO/C//OWNR01"+"/"+f_name+"."+l_name
        u_home = "/home/"+u_name
        sh_bash = "/bin/bash"
        # Iteration over hosts list and check ssh connection and create an user
        with open(m_h_name, 'r') as inp:
            for h_name in inp:
                print h_name
                try:
                    print ("Establishing ssh connection")
                    client = paramiko.SSHClient()
                    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                    client.connect(h_name,username='root')
                    stdin, stdout, stderr = client.exec_command("uptime")
                    print "Server is up and running"
                    print stdout.read()
                    stdin, stdout, stderr = client.exec_command("useradd -d %s -m -c %s -p %s -s %s %s" % (u_home, c_gecos, encrpass, sh_bash, u_name))
                    print u_name,"is created on",h_name
                except paramiko.SSHException, e:
                    print "Password is invalid:" , e
                except paramiko.AuthenticationException:
                    print "Authentication failed for some reason"
                except socket.error, e:
                    print "Socket connection failed:", e
                client.close()

# Define main function
def main():
    create_user(o_name)

# Run main function
if __name__ == '__main__':
    main()

# Remove an User
def remove_user():
    if user_inp == "2":
        print ('.' * 30) + "Removing an User" + ('.' * 30)

        # Get user name
        u_name = raw_input("Enter User name to remove:> ")
        print u_name

        # Iteration over hosts list and perform action
        with open(m_h_name, 'r') as inp:
            for h_name in inp:
                print h_name
                # Check SSH connection
                try:
                    print ("Establishing ssh connection")
                    client = paramiko.SSHClient()
                    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
                    client.connect(h_name,username='root')
                    stdin, stdout, stderr = client.exec_command("uptime")
                    print "Server is up and running"
                    print stdout.read()
                    stdin, stdout, stderr = client.exec_command("id -u %s" % (u_name))
                    exit_status=stdout.channel.recv_exit_status()
                    print exit_status
                    # Check user exist on the server with paramiko exit status
                    if exit_status == 0:
                        print u_name," exists."
                        stdin, stdout, stderr = client.exec_command("userdel -f -r %s" % (u_name))
                        print u_name,"is removed on",h_name
                        client.close()
                    if exit_status == 1:
                        print u_name," does not exist."
                    client.close()
                    print "Connection closed"
                except paramiko.SSHException, e:
                    print "Password is invalid:" , e
                except paramiko.AuthenticationException:
                    print "Authentication failed for some reason"
                except socket.error, e:
                    print "Socket connection failed:", e
                client.close()

# Define main
def main():
    remove_user()

# Run main function
if __name__ == '__main__':
    main()
