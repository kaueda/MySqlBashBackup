#!/bin/bash

backupfolder="/home/$USER/backups/$(date +'%Y.%m.%d')"

# Schema Data to be used
host="127.0.0.1"
database=""
user=""
password=""

# Verify if the arguments were given
while [[ $# > 1 ]]; do
    key="$1"

    case $key in
        -d|--database)
        database="$2"
        shift
        ;;
        -u|--user)
        user="$2"
        shift
        ;;
        -p|--password)
        password="$2"
        shift
        ;;
        *)
            echo "Unknown argument: $key $2"
        ;;
    esac
    shift
done

if [[ "$database" == "" || "$user" == "" || "$password" == "" ]]; then
    echo "Usage: ./script-backup.sh -d <database-name> -u <user-name> -p <password>"
    exit 1
fi

# Creation of the folder for storage of the daily backups 
mkdir -p "$backupfolder"

# Log archive name
logfile="$backupfolder/backup-log.txt"

# Backup process
echo ">> Mysqldump started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
mysqldump --verbose --protocol=tcp --port=3306 --default-character-set=utf8 \
--host="$host" --user="$user" --password="$password"  \
--single-transaction=TRUE --routines --events \
--databases "$database" 2>> "$logfile" > "$backupfolder/backup-$database.sql"
echo ">> Mysqldump finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"

cd "$backupfolder"
echo ">> Rar started at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
rar m "backup-$database.rar" "backup-$database.sql" >> "$logfile"
echo ">> Rar finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"

chmod -R a+rw "$backupfolder"
echo ">> Updated file permissions" >> "$logfile"
echo ">> Process finished at $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*************************************************************************************" >> "$logfile"
exit 0