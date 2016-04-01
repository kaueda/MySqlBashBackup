#!/bin/bash

backupfolder="/home/$USER/backups/$(date +'%Y.%m.%d')"

# Dados do schema a ser tratado
host="127.0.0.1"
database=""
user=""
password=""

# Verifica se foi passado algum argumento
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
            echo "Argumento desconhecido: $key $2"
        ;;
    esac
    shift
done

if [[ "$database" == "" || "$user" == "" || "$password" == "" ]]; then
    echo "Usage: ./script-backup.sh -d <database-name> -u <user-name> -p <password>"
    exit 1
fi

# Criação da pasta onde ficará os backups do dia
mkdir -p "$backupfolder"

# Nome do arquivo de log
logfile="$backupfolder/backup-log.txt"

# Iniciando o backup
echo ">> Mysqldump começou em $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
mysqldump --verbose --protocol=tcp --port=3306 --default-character-set=utf8 \
--host="$host" --user="$user" --password="$password"  \
--single-transaction=TRUE --routines --events \
--databases "$database" 2>> "$logfile" > "$backupfolder/backup-$database.sql"
echo ">> Mysqldump terminou em $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"

cd "$backupfolder"
echo ">> Rar iniciou em $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
rar m "backup-$database.rar" "backup-$database.sql" >> "$logfile"
echo ">> Rar terminou em $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"

chmod -R a+rw "$backupfolder"
echo ">> Permições de arquivos foram atualizadas" >> "$logfile"
echo ">> Operação terminada em $(date +'%d-%m-%Y %H:%M:%S')" >> "$logfile"
echo "*************************************************************************************" >> "$logfile"
exit 0