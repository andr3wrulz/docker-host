#!/bin/bash
#This will run Restic backups and remove snapshots according to a policy

LOG_FILE=/home/andr3w/logs/restic.log
BACKUP_DIR=/home/andr3w/docker

#Define a timestamp function
timestamp() {
date "+%b %d %Y %T %Z"
}

# insert timestamp into log
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a $LOG_FILE
echo "$(timestamp): restic.sh started" | tee -a $LOG_FILE

echo "Running backup: $(timestamp)" | tee -a $LOG_FILE
# Run Backups
restic backup $BACKUP_DIR

echo "Executing retention policy: $(timestamp)" | tee -a $LOG_FILE
# Remove snapshots according to policy
# If run cron more frequently, might add --keep-hourly 24
restic forget --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 10  | tee -a $LOG_FILE

echo "Cleaning up repo: $(timestamp)" | tee -a $LOG_FILE
# Remove unneeded data from the repository
restic prune

echo "Checking repo for errors: $(timestamp)"
# Check the repository for errors
restic check | tee -a $LOG_FILE

# insert timestamp into log
printf "\n\n"
echo "-------------------------------------------------------------------------------" | tee -a $LOG_FILE
echo "$(timestamp): restic.sh finished" | tee -a $LOG_FILE
