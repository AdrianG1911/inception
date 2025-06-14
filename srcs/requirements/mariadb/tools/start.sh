#!/bin/bash
set -e

# Initialize MariaDB if needed
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
  echo "Initializing MariaDB..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

  mysqld_safe --nowatch &
  sleep 5

  mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
  mariadb -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
  mariadb -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
  mariadb -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
  mariadb -e "FLUSH PRIVILEGES;"

  mysqladmin shutdown -uroot -p"${MYSQL_ROOT_PASSWORD}"
fi

# Start MariaDB normally
exec mysqld_safe