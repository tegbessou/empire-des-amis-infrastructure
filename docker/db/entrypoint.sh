#!/bin/bash
set -e

/docker-entrypoint.sh "$@" &
MYSQL_PID=$!

while ! mysqladmin ping --silent; do
    sleep 1
done

/usr/local/bin/create-users-and-databases.sh

wait $MYSQL_PID
