#!/usr/bin/env python

#########################################################
# Ref: https://lists.gt.net/python/python/881146	#
#							#
#########################################################


import os
import subprocess
import sys


## print root user can run this script
uid = os.getuid()

if uid != 0:
    print "You need to be a root user to run this script."
    sys.exit()


## create raw devices with logical volumes
# get the lv name
vg_name = raw_input("Enter VG name: ==> ")
lv_name = raw_input("Enter LV name: ==> ")
lvm_device = ("/dev" + "/" + vg_name + "/" + lv_name)
print lvm_device
d = os.stat(lvm_device)


# Get major and minor numbers for the device
mj_num = os.major(d.st_rdev)
print "LV device major number is",mj_num

mi_num = os.minor(d.st_rdev)
print "LV device minor number is",mi_num


# create raw devices
raw_dev = os.system("raw lv_dev_name mj_num mi_num")
print raw_dev


# Create udev rule for new raw device
## ENV{DM_VG_NAME}=="ditestdb6_dg", ENV{DM_LV_NAME}=="stg_datavol01", RUN+="/bin/raw /dev/raw/raw1 %N"
## ACTION=="add", ENV{MAJOR}=="3", ENV{MINOR}=="66", RUN+="/bin/raw /dev/raw/raw2 %M %m"
## ACTION=="add", ENV{MAJOR}=="mj_num", ENV{MINOR}=="mi_num", RUN+="/bin/raw /dev/raw/raw2 %M %m"
