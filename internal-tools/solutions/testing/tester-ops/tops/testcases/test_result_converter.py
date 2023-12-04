# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     test_result_converter
   Description :
   Author :        patrick
   date：          2019/10/21
-------------------------------------------------
   Change Activity:
                   2019/10/21:
-------------------------------------------------
"""
import json
import os

from .excel_converter import convert_list_to_excel

__author__ = 'patrick'


class AllureReportConverter():

    def __init__(self, report_path="allure-report/data/"):
        self.report_path = report_path
        self.__behavior_json = "behaviors.json"
        self.__suites_json = "suites.json"
        self.__behavior_csv = "behaviors.csv"
        self.__suites_json = "suites.csv"

    def generate_execl_report(self, output_path):
        behaviors_json_path = os.path.join(self.report_path, self.__behavior_json)
        json_data = self.load_behaviors_json_data(behaviors_json_path)
        epics = json_data.get("children", "")
        test_results = []
        for epic in epics:
            for feature in epic.get("children", []):
                for test_case in feature.get("children", []):
                    result = AllureTestResult(epic.get("name", ""))
                    result.feature = feature.get("name")
                    result.test_case = test_case.get("name")
                    result.test_case_result = test_case.get("status", "failed")
                    test_results.append(result.to_tuple())
        ##todo: add config mapping
        convert_list_to_excel(test_results, output_path, "测试模块", "测试功能", "测试用例", "测试结果")

    @staticmethod
    def load_behaviors_json_data(behaviors_json_path):
        with open(behaviors_json_path, 'r') as json_file:
            json_data = json.load(json_file)
        return json_data


class AllureTestResult:

    def __init__(self, epic_name):
        self._epic = epic_name

    @property
    def epic(self):
        return self._epic

    @epic.setter
    def epic(self, value):
        self._epic = value

    @property
    def feature(self):
        return self._feature

    @feature.setter
    def feature(self, value):
        self._feature = value

    @property
    def test_case(self):
        return self._test_case

    @test_case.setter
    def test_case(self, value):
        self._test_case = value

    @property
    def test_case_result(self):
        return self._test_case_result

    @test_case_result.setter
    def test_case_result(self, value):
        self._test_case_result = value

    def to_tuple(self):
        return (self._epic, self._feature, self._test_case, self._test_case_result)
