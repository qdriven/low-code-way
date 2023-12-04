# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     run_environment
   Description :
   Author :        patrick
   date：          2019/10/19
-------------------------------------------------
   Change Activity:
                   2019/10/19:
-------------------------------------------------
"""
from . import utils as U

__author__ = 'patrick'


def check_appium():
    appium = U.cmd("appium -v")\
        .stdout.readline().rstrip()
    if '1.' not in appium:
        U.Logging.error('appium is not installed,please install it')
        exit(1)
    else:
        U.Logging.info('appium version {}'.format(appium))
