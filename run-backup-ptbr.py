#!/usr/bin/env python
import sys
import os
import MySQLdb

if (len(sys.argv) != 5):
    sys.exit("Quantidade de argumentos eh invalida.\n    Usage: python run-backup.py <host> <user> <password> <database>")

db = MySQLdb.connect(host=sys.argv[1],    # ip do servidor de banco de dados ex.: "localhost"
                     user=sys.argv[2],    # nome de usuario ex.: "root"
                     passwd=sys.argv[3],  # senha do banco de dados ex.: "root123456"
                     db=sys.argv[4])      # nome do banco de dados ex.: "dbbackup-info"

# Cursor para buscas no banco
cur = db.cursor()
cur.execute("select * from `schemas-info`")

# Cria o backup para cada banco existente
for row in cur.fetchall():
    print("./script-backup.sh --database %s --user %s --password %s" % (row[1], row[2], row[3]))
    os.system("./script-backup.sh --database %s --user %s --password %s" % (row[1], row[2], row[3]))

db.close()