# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     test_allureReportConverter
   Description :
   Author :        patrick
   date：          2019/10/21
-------------------------------------------------
   Change Activity:
                   2019/10/21:
-------------------------------------------------
"""
from unittest import TestCase

from testcases.test_result_converter import AllureReportConverter, AllureTestResult

__author__ = 'patrick'


class TestAllureReportConverter(TestCase):

    def setUp(self):
        self.converter = AllureReportConverter()

    def test_generate_execl_report(self):
        self.converter.generate_execl_report("allure_result_files.xls")


