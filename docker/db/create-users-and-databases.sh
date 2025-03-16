#!/bin/bash
set -e

sleep 10

: "${DB_HOST:=localhost}"
: "${DB_PORT:=3306}"
: "${MYSQL_ROOT_USER:=root}"
: "${MARIADB_ROOT_PASSWORD:?Variable MARIADB_ROOT_PASSWORD non définie}"

: "${EDA_USER_PASSWORD:?Variable EDA_USER_PASSWORD non définie}"
: "${EDA_COUNTRY_PASSWORD:?Variable EDA_COUNTRY_PASSWORD non définie}"
: "${EDA_BOTTLE_INVENTORY_PASSWORD:?Variable EDA_BOTTLE_INVENTORY_PASSWORD non définie}"
: "${EDA_TASTING_PASSWORD:?Variable EDA_TASTING_PASSWORD non définie}"

declare -A users
users["eda_user"]="${EDA_USER_PASSWORD}"
users["eda_country"]="${EDA_COUNTRY_PASSWORD}"
users["eda_bottle_inventory"]="${EDA_BOTTLE_INVENTORY_PASSWORD}"
users["eda_tasting"]="${EDA_TASTING_PASSWORD}"

for user in "${!users[@]}"; do
  password="${users[$user]}"
  database="${user}"  # Ici, la base de données porte le même nom que l'utilisateur.

  echo "Traitement de l'utilisateur '${user}' et de la base de données '${database}'..."

  # Vérifier si l'utilisateur existe déjà
  USER_EXISTS=$(mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${MYSQL_ROOT_USER}" -p"${MARIADB_ROOT_PASSWORD}" -sN -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = '${user}');")
  if [ "$USER_EXISTS" -eq 1 ]; then
    echo "L'utilisateur '${user}' existe déjà."
  else
    echo "Création de l'utilisateur '${user}'..."
    mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${MYSQL_ROOT_USER}" -p"${MARIADB_ROOT_PASSWORD}" -e "CREATE USER '${user}'@'%' IDENTIFIED BY '${password}';"
  fi

  # Créer la base de données si elle n'existe pas
  echo "Création de la base de données '${database}' si elle n'existe pas..."
  mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${MYSQL_ROOT_USER}" -p"${MARIADB_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${database}\`;"

  # Accorder les privilèges sur la base de données à l'utilisateur
  echo "Attribution des privilèges pour '${user}' sur la base '${database}'..."
  mysql -h "${DB_HOST}" -P "${DB_PORT}" -u "${MYSQL_ROOT_USER}" -p"${MARIADB_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${database}\`.* TO '${user}'@'%'; FLUSH PRIVILEGES;"
done

echo "Création des utilisateurs et des bases de données terminée."
