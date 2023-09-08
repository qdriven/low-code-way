#!/usr/bin/python
# -*- coding: utf-8 -*-

import MySQLdb as mdb
import sys

try:
    con = mdb.connect('localhost', 'testuser', 'test623', 'testdb');
    
    cur = con.cursor()
    cur.execute("show status like 'Max_used_connections'")
 
    #ver = cur.fetchone()
    uconn = cur.fetchall()
    
    
    print uconn
    
except mdb.Error, e:
  
    print "Error %d: %s" % (e.args[0],e.args[1])
    sys.exit(1)
