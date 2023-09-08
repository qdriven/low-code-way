#!/usr/bin/env python

import os
import re

# Check SELinux status
# check os, check /etc/sysconfig/selinux and status
se_linux = './selinux'
se_linuxo = './selinuxo'

with open (se_linux, "r") as inp,open (se_linuxo, "w") as ou:
    for l in inp.readlines():
        l = re.sub(r"^SELINUX=enforcing", "SELINUX=disabled", l)
        ou.write(l)
        #print "SELINUX is disabled\n"


if os.path.exists(se_linux):
    os.rename(se_linux, se_linux+'.old')
os.rename(se_linuxo, se_linux)
