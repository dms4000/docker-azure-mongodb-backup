#!/bin/bash

# Load environment variables
source /env/.env
#source .env

# Variables
BACKUP_DIR="./$(date +%F)"
RETENTION_DAYS=7

# Create backup directory
mkdir -p $BACKUP_DIR

# Run mongodump
#mongodump --uri=$URI --out $BACKUP_DIR
mongodump --host $HOST --port $PORT --username $USER --password $PASSWORD --authenticationDatabase $AUTH_DB --ssl --out $BACKUP_DIR

# Compress the backup
#tar -czf ${BACKUP_DIR}.tar.gz -C ./ $(date +%F)
tar -czf ${BACKUP_DIR}.tar.gz $(date +%F)

# Upload to Azure Blob Storage
# Export variables to ensure they are available to child processes

az storage blob upload --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_KEY --container-name $AZURE_STORAGE_CONTAINER --file ${BACKUP_DIR}.tar.gz --name $(date +%F).tar.gz

# Clean up local backup files
rm -rf $BACKUP_DIR
rm ${BACKUP_DIR}.tar.gz

# Find and delete backups older than retention period in blob storage

NUMBER_OF_EXISTING_FILES=$(exec az storage blob list\
    --account-name $AZURE_STORAGE_ACCOUNT\
    --account-key $AZURE_STORAGE_KEY\
    --container-name $AZURE_STORAGE_CONTAINER\
    | grep 'name' | wc -l)

if [[ "$NUMBER_OF_EXISTING_FILES" -ge "$RETENTION_DAYS" ]] ; then
    OLD_DATE=$(date -d "-${RETENTION_DAYS} days" +%F)
    az storage blob delete --account-name $AZURE_STORAGE_ACCOUNT --account-key $AZURE_STORAGE_KEY --container-name $AZURE_STORAGE_CONTAINER --name ${OLD_DATE}.tar.gz
fi

echo $BODY | mail --config-verbose -s $SUBJECT $EMAIL > /var/log/azure_mongo_backup.log 2>&1

logger -t azure_mongo_backup "Email sent or failed, check /var/log/azure_mongo_backup.log"