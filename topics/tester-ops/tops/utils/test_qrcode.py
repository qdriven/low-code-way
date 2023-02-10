# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     test_qrcode
   Description :
   Author :        patrick
   date：          2019/10/10
-------------------------------------------------
   Change Activity:
                   2019/10/10:
-------------------------------------------------
"""
from unittest import TestCase

from utils import qr_codes

__author__ = 'patrick'


class TestQRCodes(TestCase):
    def test_generate_qr_for_url(self):
        qr_codes.generate_qr_for_url("http://www.baidu.com", "baidu")

    def test_generate_qr_for_url_with_saved_path(self):
        qr_codes.generate_qr_for_url("http://www.baidu.com", "baidu","../")