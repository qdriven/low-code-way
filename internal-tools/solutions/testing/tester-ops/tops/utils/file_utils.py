# -*- coding: utf-8 -*-

"""
-------------------------------------------------
   File Name：     file_utils
   Description :
   Author :        patrick
   date：          2019/10/19
-------------------------------------------------
   Change Activity:
                   2019/10/19:
-------------------------------------------------
"""
__author__ = 'patrick'

import os
import collections


def list_files_with_extname(root_directory, extension_name):
    """

    :return: 遍历文件目录
    """
    file_dic = collections.OrderedDict()
    for parent, dirnames, filenames in os.walk(root_directory):
        for filename in filenames:
            if 'filter' not in filename:
                if filename.endswith(extension_name):
                    path = os.path.join(parent, filename).replace('\\', '/')
                    file_dic[filename] = path
    return file_dic
