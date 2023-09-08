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


## create raw devices with native devices
# get the native device details
dev_name = raw_input("Enter device name: ")
d = os.stat(dev_name)


# Get major and minor numbers for the device
mj_num = os.major(d.st_rdev)
print "Device major number is",mj_num

mi_num = os.minor(d.st_rdev)
print "Device minor number is",mi_num


# Create raw device
raw_dev = os.system("raw dev_name mj_num mi_num")
print raw_dev


# Update details into udev
# An example would be:
#   ACTION=="add", KERNEL=="sda", RUN+="/usr/bin/raw /dev/raw/raw1 %N"
# to bind /dev/raw/raw1 to /dev/sda, or
#   ACTION=="add", ENV{MAJOR}=="8", ENV{MINOR}=="1", RUN+="/usr/bin/raw /dev/raw/raw2 %M %m"
# to bind /dev/raw/raw2 to the device with major 8, minor 1.
