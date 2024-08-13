#!/bin/bash

CONTAINER_NAME=renthub-db
DB_USERNAME="hugodvd"
DUMPS_FOLDER="./dumps"
RCLONE_REMOTE_NAME="renthub-dumps"
RCLONE_REMOTE_FOLDER="_WCS/RENTHUB/dumps"

docker exec $CONTAINER_NAME pg_dumpall -c -U $DB_USERNAME > $DUMPS_FOLDER/pg_`date +%Y-%m-%d"_"%H-%M-%S`.sql
rclone sync $DUMPS_FOLDER $RCLONE_REMOTE_NAME:$RCLONE_REMOTE_FOLDER