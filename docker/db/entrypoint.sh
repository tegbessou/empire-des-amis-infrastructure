docker/db/entrypoint.sh#!/bin/bash
set -e

/usr/local/bin/docker-entrypoint.sh "$@" &
MYSQL_PID=$!

while ! mysqladmin ping --silent; do
    sleep 1
done

sudo /usr/local/bin/create-users-and-databases.sh

wait $MYSQL_PID
