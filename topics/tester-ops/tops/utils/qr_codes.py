# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     qr_codes
   Description :
   Author :        patrick
   date：          2019/10/10
-------------------------------------------------
   Change Activity:
                   2019/10/10:
-------------------------------------------------
"""
import os

import pyqrcode

__author__ = 'patrick'


def generate_qr_for_url(url, qr_name, saved_dir="."):
    qr = pyqrcode.create(url)
    qr_path = os.path.join(saved_dir, qr_name + ".png")
    qr.png(qr_path, scale=12)
    print("QRCodes")
    print(qr.terminal())
