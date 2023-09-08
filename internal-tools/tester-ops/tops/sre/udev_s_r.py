#!/usr/bin/env python

import os
import re

# Check SELinux status
# check os, check /etc/sysconfig/selinux and status
f_in = './60-raw.rules'
f_ou = './60-raw.ruleso'
f_insert = 'ENV{DM_VG_NAME}=="test_ditestdb6_dg", ENV{DM_LV_NAME}=="test_datavol01", RUN+="/bin/raw /dev/raw/raw1 %N"\n'
n_line = "\n"

with open (f_in, "r") as inp,open (f_ou, "w") as ou:
    for l in inp.readlines():
        if re.match("# To set permissions:", l):
            #ou.write("ENV{DM_VG_NAME}=="test_ditestdb6_dg"\, ENV{DM_LV_NAME}=="test_datavol01"\, RUN+="/bin/raw /dev/raw/raw1 %N"")
            ou.write(f_insert)
            ou.write(n_line) 
        ou.write(l)


if os.path.exists(f_in):
    os.rename(f_in, f_in+'.old')
os.rename(f_ou, f_in)
