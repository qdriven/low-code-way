# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     __init__.py
   Description :
   Author :        patrick
   date：          2019/10/19
-------------------------------------------------
   Change Activity:
                   2019/10/19:
-------------------------------------------------
"""
import os
import platform

__author__ = 'patrick'

system = platform.system()
CURR_SCRIPT_PATH = os.path.dirname(__file__)


def get_adb_runtime():
    if "ANDROID_HOME" in os.environ:
        BASE_PATH = os.path.join(
            os.environ["ANDROID_HOME"],
            "platform-tools")
        if system == "Windows":
            executor = os.path.join(BASE_PATH,
                                    "adb.exe")
        else:
            executor = os.path.join(BASE_PATH, "adb")
    else:
        raise EnvironmentError("please setup ANDROID_HOME")

    return executor


ADB_SHELL = get_adb_runtime()
