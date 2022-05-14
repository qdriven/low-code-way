#!/usr/bin/env python

## Refer Linux tech spec ##

import os
import platform
import pwd
import sys
import multiprocessing
import netifaces
import re
import subprocess

# check virtual or physical
print ('.' * 10) + (" System detail ") + ('.' * 10)
#print "Manufacturer: %s" % (os.system("dmidecode -s system-manufacturer"))
#print "Product Name: %s" % (os.system("dmidecode -s system-product-name"))
#print "Version: %s" % (os.system("dmidecode -s system-version"))
#print "Serial Number: %s" % (os.system("dmidecode -s chassis-serial-number"))
(os.system("dmidecode -s system-manufacturer"))
(os.system("dmidecode -s system-product-name"))
(os.system("dmidecode -s system-version"))
(os.system("dmidecode -s chassis-serial-number"))

#check_prod_name = subprocess.call(['dmidecode', '-s', 'system-manufacturer'])
#if (check_prod_name == "KVM") or (check_prod_name == "VMware Virtual Platform") or (check_prod_name == "Virtual Box"):
#if "KVM" or "VMware Virtual Platform" or "Virtual Box" in check_prod_name:
#if "HP" or "Dell" or "IBM" or "LENOVO" or "Supermicro" in check_prod_mode:
#if D or H or I or L or S in check_prod_name: 
#    print "===> Virtual Machine <===\n"
#else:
#    print "===> Physical Machine <===\n"

# Number of cpu
print "\n"
print ('.' * 10) + (" System CPU\'s detail ") + ('.' * 10)
no_of_cpu = multiprocessing.cpu_count()
print " %s \n" % (no_of_cpu)

# Amount of RAM
print ('.' * 10) + (" System memory detail ") + ('.' * 10)
sys_mem = os.system("free --si -h | grep 'Mem:' | awk '{print $2}'")
print "\n"

# Allocated disks/drives
print ('.' * 10) + (" System drives detail ") + ('.' * 10)
sys_drives = os.system("lsscsi -s")
print "\n"

# get hostname
#hn = platform.node()
#print "Hostname =====> %s <=====""\n" % (hn)

# Check /etc/resolv.conf
print ('.' * 10) + (" System DNS resolver detail ") + ('.' * 10)
f = '/etc/resolv.conf'
if os.path.isfile(f):
    print f,"is exist"
else:
    print f,"Doesn\'t exit"

f1 = open(f, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    #if "search" and "ibm.com" in l:
        #print "===> search ibm.com <===\n"
    print l

f1.close()
# Check firewall and selinux status, must be disabled
print ('.' * 10) + (" System firewall detail ") + ('.' * 10)
def check_fw():
    firewall = os.system("systemctl is-active firewalld > /dev/null")
    return firewall

def main():
    if check_fw() == 0:
        print ('.' * 10) + " firewalld is running " + ('.' * 10)
        print "\n" 
    else:
        print ('.' * 10) + " firewalld is NOT running " + ('.' * 10)
        print "\n"
main()

# Check SELinux status
# check os, check /etc/sysconfig/selinux and status
#OS_version = platform.linux_distribution()
print ('.' * 10) + (" System SELINUX status ") + ('.' * 10)
se_linux = '/etc/sysconfig/selinux'

f = open(se_linux, 'r')
f_rl = f.readlines()
for l in f_rl:
    if re.match("^SELINUX=enforcing", l):
        print "SELINUX is enabled\n"

f.close()
# Check running services status

# Check OS and Kernel level
print ('.' * 10) + (" System Hostname, OS, and Kernel detail ") + ('.' * 10)
print ("""Hostname: %r
Python version: %r
OS version: %r
Kernel version: %r
Kernel architecture: %r
Processor architecture: %r
""" % (
platform.node(),
platform.python_version(),
platform.linux_distribution(),
platform.release(),
platform.machine(),
platform.processor(),
))

# LVM

# List of file systems

# get ip and subnet mask
## https://www.programcreek.com/python/example/83930/netifaces.AF_INET6
print ('.' * 10) + (" System IP and Netmask detail ") + ('.' * 10)
ifaces = netifaces.interfaces()

for iface in ifaces:
    ipaddr = netifaces.ifaddresses(iface)
    if netifaces.AF_INET in ipaddr:
        addr = ipaddr[netifaces.AF_INET][0]['addr']
        netmask = ipaddr[netifaces.AF_INET][0]['netmask']
        print "Interface ==> %s <==" % (iface)
        print "IPAddress is ==> %s <==, Netmask is ==> %s <==""\n" % (addr, netmask)
         
# get default gateway
gws = netifaces.gateways()

try:
    print ('.' * 10) + " Default gateway " + ('.' * 10)
    print gws['default'][netifaces.AF_INET],"\n"
except KeyError:
    print gws['default'][netifaces.AF_INET6]

# get ip route
#print "\n"
print ('.' * 10) + " System IP route detail " + ('.' * 10)
ip_route = os.system("ip r show")
print "\n"

# get issue, issue.net

# get motd

# Password Requirements: PASS_MAX_DAYS
f = './login.defs'
if os.path.isfile(f):
    print f,"is exist"
else:
    print f,"doesn\'t exist"

f1 = open(f, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    if "PASS_MAX_DAYS" and "90" in l:
        print "Default maximum password age is set to ==> 90 days <==","\n"
        break
#    else:
        #print "Set max password age to '90'."

f1.close()

# Password Requirements: Minimum Password Age
f = './login.defs'
if os.path.isfile(f):
    print f,"is exist"
else:
    print f,"doesn\'t exist"

f1 = open(f, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    if "PASS_MIN_DAYS" and "1" in l:
        print "Default minimum password age is set to ==> 1 day <==","\n"
        break
#    else:
        #print "Set max password age to '90'."

f1.close()

# Password Requirements: Minimum Password Length
f = './login.defs'
if os.path.isfile(f):
    print f,"is exist"
else:
    print f,"doesn\'t exist"

f1 = open(f, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    if "PASS_MIN_LEN" and "8" in l:
        print "Default minimum password length is set to ==> 8 <==","\n"
        break
#    else:
        #print "Set max password age to '90'."

f1.close()

# Password Requirements: Encrypt method
f = './login.defs'
if os.path.isfile(f):
    print f,"is exist"
else:
    print f,"doesn\'t exist"

f1 = open(f, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    if "ENCRYPT_METHOD" and "MD5" in l:
        print "Default encrypt method is set to ==> MD5 <==","\n"
        break
#    else:
        #print "Set max password age to '90'."

f1.close()

# Password Requirements: /etc/ssh/sshd_config
# Prevent ssh login from bypassing pam by setting "UsePAM yes".
ssh_file = '/etc/ssh/sshd_config'
if os.path.isfile(ssh_file):
    print ssh_file,"is exist"
else:
    print ssh_file,"doesn\'t exist"

f1 = open(ssh_file, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    if "UsePAM" and "yes" in l:
        print "==> UsePAM yes <==","\n"
        break
#    else:
        #print "Set max password age to '90'."

f1.close()

# Password Requirements: PASS_MIN_LEN, password complexity
# retry=3 minlen=8 dcredit=-1 ucredit=0 lcredit=-1 ocredit=0 type= reject_username
sys_auth = '/etc/pam.d/system-auth'
if os.path.isfile(sys_auth):
    print sys_auth,"is exist"
else:
    print sys_auth,"doesn\'t exist"

f1 = open(sys_auth, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    if ("password") and ("required") and ("retry=3" and "minlen=8" and "dcredit=-1" and "ucredit=0" and "lcredit=-1" and "ocredit=0" or "type= reject_username") in l: 
        print "Password complexity is ==> OK <==","\n"
        break
#    else:
        #print "Set max password age to '90'."

f1.close()

# Password Requirements: Password History
# Debian: password    sufficient    pam_unix.so remember=7 use_authtok md5 shadow
# Red Hat: password   sufficient   pam_unix.so remember=8 nullok use_authtok sha512 shadow
sys_auth = '/etc/pam.d/system-auth'
if os.path.isfile(sys_auth):
    print sys_auth,"is exist"
else:
    print sys_auth,"doesn\'t exist"

f1 = open(sys_auth, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    if "password" and "sufficient" and "remember=8" or "remember=7" in l:
        print "Password history is ==> OK <==","\n"
        break
#    else:
        #print "Set max password age to '90'."

f1.close()

# Password Requirements: loginretries
# auth        required      pam_tally2.so deny=5 onerr=fail
sys_auth = '/etc/pam.d/system-auth'
if os.path.isfile(sys_auth):
    print sys_auth,"is exist"
else:
    print sys_auth,"doesn\'t exist"

f1 = open(sys_auth, 'r')
f1_rl = f1.readlines()
for l in f1_rl:
    if "deny=5" and "onerr=fail" in l:
        print "Password loginretries is ==> SET <==","\n"
        break

f1.close()

# : login shells for system ID's
print ('.' * 10) + " Login shells for System ID's " + ('.' * 10)
no_login = '/sbin/nologin'
usr_no_login = '/usr/sbin/nologin'
fal_se = '/bin/false'
sy_nc = '/bin/sync'
shut_down = '/sbin/shutdown'
ha_lt = '/sbin/halt'

## Read /etc/passwd file
all_user_data = pwd.getpwall()

## Iterate over user data
for u in all_user_data: 
    Username = u.pw_name
    Password = u.pw_passwd
    Comment = u.pw_gecos
    UID = u.pw_uid
    GID = u.pw_gid
    Home = u.pw_dir
    Shell = u.pw_shell
    ## Check other shells and apply service label 
    if UID <= 500 and Shell == no_login or Shell == usr_no_login or Shell == fal_se or Shell == sy_nc or Shell == shut_down or Shell == ha_lt:
        print Username,Shell,"\n"
        #r_s_lbl = (s_lbl + '/' + Username)
        #r_s_lbl_cmd = subprocess.call(('usermod', '-c', r_s_lbl, Username))
        #r_s_lbl_cmd
    #else:
    #print "non IBM label"

# : /etc/ftpusers or /etc/vsftpd.ftpusers

# : checking logging parameters
print ('.' * 10) + " System logging details  " + ('.' * 10)
rslog = '/etc/rsyslog.conf'

f = open(rslog, 'r')
f_rl = f.readlines()
for l in f_rl:
    if os.path.isfile("/var/log/messages"):
        if "*.info;mail.none;authpriv.none;cron.none" and "/var/log/messages" in l:
            print "System is configured to send system logs to \'/var/log/messages'"
    if os.path.isfile("/var/log/secure"):
        if "authpriv.*" and "/var/log/secure" in l:
            print "System is configured to send secure logs to \'/var/log/secure'"
    if os.path.isfile("/var/log/maillog"):
        if "mail.*" and "-/var/log/maillog" in l:
            print "System is configured to send mail logs to \'/var/log/maillog'"
    if os.path.isfile("/var/log/cron"):        
        if "cron.*" and "/var/log/cron" in l:
            print "System is configured to send cron logs to \'/var/log/cron'"
    if os.path.isfile("/var/log/spooler"):
        if "uucp,news.crit" and "/var/log/spooler" in l:
            print "System is configured to send uucp,news logs to \'/var/log/spooler'"
    if os.path.isfile("/var/log/boot.log"):
        if "local7.*" and "/var/log/boot.log" in l:
            print "System is configured to send boot logs to \'/var/log/boot.log'\n"

f.close()
    


