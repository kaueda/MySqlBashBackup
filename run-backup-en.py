#!/usr/bin/env python
import sys
import os
import MySQLdb

if (len(sys.argv) != 5):
    sys.exit("Invalid quantity of arguments.\n    Usage: python run-backup.py <host> <user> <password> <database>")

db = MySQLdb.connect(host=sys.argv[1],    # database server IP ex.: "localhost"
                     user=sys.argv[2],    # user name ex.: "root"
                     passwd=sys.argv[3],  # database password ex.: "root123456"
                     db=sys.argv[4])      # database schema name ex.: "dbbackup-info"

# Database cursor
cur = db.cursor()
cur.execute("select * from `schemas-info`")

# # Creates a backup file for each schema
for row in cur.fetchall():
    print("./script-backup.sh --database %s --user %s --password %s" % (row[1], row[2], row[3]))
    os.system("./script-backup.sh --database %s --user %s --password %s" % (row[1], row[2], row[3]))

db.close()