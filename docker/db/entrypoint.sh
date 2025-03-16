#!/bin/bash
set -e

/usr/local/bin/docker-entrypoint.sh "$@" &
MYSQL_PID=$!

while ! mysqladmin ping --silent; do
    sleep 1
done

echo "Script exécuté par l'utilisateur : $(whoami)"

/usr/local/bin/create-users-and-databases.sh

wait $MYSQL_PID
