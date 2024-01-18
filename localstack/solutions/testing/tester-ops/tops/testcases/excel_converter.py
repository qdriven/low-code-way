# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     excel_converter
   Description :
   Author :        patrick
   date：          2019/10/21
-------------------------------------------------
   Change Activity:
                   2019/10/21:
                   reference site: http://www.python-excel.org/
-------------------------------------------------
"""
__author__ = 'patrick'

from openpyxl import Workbook


def convert_list_to_excel(content, file_name, *headers):
    column_range = len(headers)
    content.insert(0, headers)
    wb = Workbook()
    ws = wb.active
    for row_index in range(len(content)):
        for col_index in range(column_range):
            ws.cell(row=row_index + 1, column=col_index + 1).value= content[row_index][col_index]
    # print(index)
    return wb.save(file_name)


if __name__ == '__main__':
    result = convert_list_to_excel([("test1", "test2", "test3"), ("test1", "test2", "test3")
                                    ], "test_exel.xls", "th1", "th2", "th3")
#     print(result)
