# encoding: utf-8
import sys

import pymongo as pymongo

host = '219.234.6.180'
port = 27017
user = 'tops'
pwd = 'tops'
dbname = 'admin'


class DBDriver:

    def mysql_driver_test(self):
        try:
            import MySQLdb
            print("MySQL python driver is ok!")
        except Exception as e:
            print("MySQL Driver is not ready,", e)

    def oracle_driver_test(self):
        try:
            import cx_Oracle
            print("oracle python driver is ok!")
        except Exception as e:
            print("MySQL Driver is not ready,", e)

    def sqlserver_driver_test(self):
        try:
            import pymssql
            print("sql server python driver is ok!")
        except Exception as e:
            print("sql server Driver is not ready,", e)

    def redis_driver_test(self):
        try:
            import redis
            print("sql server python driver is ok!")
        except Exception as e:
            print("sql server Driver is not ready,", e)
