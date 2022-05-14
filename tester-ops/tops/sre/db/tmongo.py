# encoding: utf-8
import sys

import pymongo as pymongo

host = '219.234.6.180'
port = 27017
user = 'tops'
pwd = 'tops'
dbname = 'admin'


class MongoDriver:

    def connection_test(self):
        try:
            connect = pymongo.Connection(host, int(port))
            db = connect[dbname]
            db.authenticate(user, pwd)
            print("MongoDB server connect success!")
        except Exception as e:
            print(e)
            sys.exit(1)
        finally:
            sys.exit(1)

    def driver_test(self):
        try:
            import pymongo
            import bson
            print("MongoDB python drivier is ok!")
        except Exception as e:
            print("MongoDB Driver is not ready,",e)
