# MySqlBashBackup
A bash script for automatically creating a mysql backup with rar compression.

## Contents
1. [A little bit more than that](#a-little-bit-more-than-that)
1. [Table schemas-info structure](#table-schemas-info-structure)
1. [Compression method](#compression-method)
1. [Dependencies](#dependencies)

## A little bit more than that
Besides the script-backup.sh I made a run-backup.py script to get from a mysql
schema a table with database information for backup.

It essentially grabs the info in the database and passes to the script-backup.sh
and after that the script will create a folder in your home called "backups".

The backup is stored in a folder with the date of the backup in the format "yyyy.mm.dd"
and that way you can easily sort your backups. You can change the script to add hour to the
name of this folder if you make hourly backups, just change:
```bash
backupfolder="/home/$USER/backups/$(date +'%Y.%m.%d')"
```
to:
```bash
backupfolder="/home/$USER/backups/$(date +'%Y.%m.%d.%H')"
```
If you want more information about the date format you can visit [here](http://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/)

## Table schemas-info structure
You need a table called "schemas-info" in one of your databases if you want 
the run-backup.py script to work (this exact table)

id | database_name |             user_name              |        password
---|---------------|------------------------------------|-----------------------|
1  | your database | user allowed to change the database| password for the user |

If you're not sure how to do this you can have this:
```sql
CREATE SCHEMA IF NOT EXISTS `dbschema_info` DEFAULT CHARACTER SET utf8 ;

DROP TABLE IF EXISTS `schemas-info`;
CREATE TABLE `schemas-info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `schema_name` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

INSERT INTO `schemas-info` (`schema_name`, `username`, `password`) VALUES ('mydb-exemple','myroot','mypass');
```

## Compression method
In this script I optioned for the .rar compression, but it's not a free
software and not every one can use/buy it. You can change this part:
```bash
cd "$backupfolder"
echo ">> Rar started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
rar m "backup-$database.rar" "backup-$database.sql" >> "$logfile"
echo ">> Rar finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
```
to:
```bash
cd "$backupfolder"
echo "gzip started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
gzip -c "backup-$database.sql" > "backup-$database.gz"
echo "gzip finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
```

## Dependencies
You will need:

1. mysqldump (comes with the MySql Workbench) : `sudo apt-get install mysql-workbench` or `sudo apt-get install mysql-utilities`
2. rar (or any other compression software you'd like).
This is the avaliation version, you shloud buy it or change the compression method : `sudo apt-get install rar`
3. python 2.7 (comes with most linux distros) : `sudo apt-get install python2.7`
4. MySQLdb python package python-mysqldb : `sudo apt-get install python-mysqldb`
