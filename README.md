# docker-azure-mongodb-backup

The script helps to make backup of your Azure mongoDB every day.


## .env File

.env file should be in the same folder

### MongoDB credentials

> HOST=\
PORT=\
USER=\
PASSWORD=\
AUTH_DB=admin

### Azure storage credentials

> AZURE_STORAGE_ACCOUNT=\
AZURE_STORAGE_CONTAINER=\
AZURE_STORAGE_KEY=

### Email credentials

> EMAIL=\
MAILX_PASSWORD=\
SUBJECT="MongoDB Backup Status"\
BODY="MongoDB backup completed successfully on $(date)


By default this scipt runs job at 04:00 AM every day. You can edit Dockerfile to change it.

## mail.rc File

> set smtp-use-starttls\
set smtp=smtp:// \
set smtp-auth=login\
set smtp-auth-user=$EMAIL\
set smtp-auth-password=$MAILX_PASSWORD\
set from=$EMAIL

## Deploying the container

### Build and push your Docker image to ACR:

> docker build -t azure_mongo_backup .\
docker tag azure_mongo_backup **MyContainerRegistry**.azurecr.io/azure_mongo_backup:latest\
docker push **MyContainerRegistry**.azurecr.io/azure_mongo_backup:latest
