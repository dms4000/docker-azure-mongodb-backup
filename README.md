# docker-azure-mongodb-backup



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


By default this scipt runs job at 04:00 AM every day. You can edit Dockerfile to change it.

## Deploy the container

### Build and push your Docker image to ACR:

> docker build -t mongodb-backup .\
docker tag mongodb-backup **MyContainerRegistry**.azurecr.io/azure_mongo_backup:latest\
docker push **MyContainerRegistry**.azurecr.io/azure_mongo_backup:latest
