import os
import sys
import subprocess


## print root user can run this script
uid = os.getuid()

if uid != 0:
    print "You need to be a root user to run this script."
    sys.exit()


##
new_pv = "1"
new_vg = "2"
new_lv = "3"
ext_vg = "4"
#ext_lv = "5"

new_or_ext = raw_input("Enter 1 to create a PV, 2 to create a VG, 3 to create a lv, 4 to extend the VG, 5 to extend the LV: ")


## 
if new_or_ext == "1":
    print "Creating a PV"
    pv_name = raw_input("Enter PV name: ")
    print pv_name
    os.system('pvcreate pv_name')

elif new_or_ext == "2":
    print "Creating a VG"
    vg_name = raw_input("Enter VG name: ")
    print vg_name
    pv_name = raw_input("Enter PV name: ")
    print pv_name
    os.system('vgcreate vg_name pv_name')

elif new_or_ext == "3":
    print "creating a LV"
    lv_name = raw_input("Enter LV name: ")
    print lv_name
    vg_name = raw_input("Enter VG name: ")
    print vg_name
    lv_size = raw_input("Enter LV size: ")
    if ("M" in lv_size) or ("G" in lv_size):
        #print "lv_name in lv_m_g"
        print "Creating lv......"
        #os.system('lvcreate --size lv_ssize --name lv_name vg_name')
        subprocess.call(('lvcreate', '-L', lv_size, '-n', lv_name, vg_name))
    #elif "G" in lv_size:
    #    print "Creating lv... in GB"
    #    #os.system("lvcreate -L  lv_size -n lv_name vg_name")
    #    subprocess.call(('lvcreate', '-L', lv_size, '-n', lv_name, vg_name))
    else:
        print ("Enter LV size with M for MB or G for GB to proceed ==> Example: 1024M or 1G <==")
    
elif new_or_ext == "4":
    print "Extending the VG"
    vg_name = raw_input("Enter VG name: ")
    pv_name = raw_input("Enter PV name: ")
    print pv_name
    os.system("pvcreate pv_name")
    print vg_name
    os.system("vgextend vg_name pv_name")
'''
elif new_or_ext == "5":
    print "Extedning the LV"
    lv_name = raw_input("Enter LV name: ")
    lv_size = raw_input("Enter LV size: ")
    # check available disk space in VG
    #vg_frespace = subprocess.call('vgs', '-o vg_free', '--noheadings')
    vg_frespace = os.system("vgs -o vg_free --noheadings")
    if (lv_size < vg_frespace):
        print "vg has free disk space"
    else:
        print "vg has no free disk space"
    #print vg_frespace
'''
## get the pv name
## pv_name = raw_input("Enter PV name: ")
## print pv_name

## get the vg name
# vg_name = raw_input("Enter VG name: ")
# print vg_name

## get the lv  name
## lv_name = raw_input("Enter LV name: ")
## print lv_name

## output the lvm device path
## print ("/" + "dev" + "/" + vg_name + "/" + lv_name)
## conf_dev = raw_input("Confirm(y/n): ")
