# Use a base image with MongoDB tools installed
FROM mongo:latest

# Install dependencies
RUN apt-get update && apt-get install -y cron curl apt-transport-https lsb-release gnupg dos2unix

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Copy backup script into the container
COPY azure_mongo_backup.sh /usr/local/bin/azure_mongo_backup.sh

# Copy the .env file into the container
COPY .env /env/.env
RUN dos2unix /env/.env

# Make the script executable
RUN chmod +x /usr/local/bin/azure_mongo_backup.sh

# Set up a cron job
RUN echo "cat /env/.env >> /etc/cron.d/mongodb-backup"
RUN echo "9 11 * * * /usr/local/bin/azure_mongo_backup.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/mongodb-backup

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/mongodb-backup

# Apply cron job
RUN crontab /etc/cron.d/mongodb-backup

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
