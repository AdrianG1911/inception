#!/bin/bash
set -e

# Create the runtime directory for the socket file. This is correct.
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# --- THIS IS THE FINAL, CRITICAL FIX ---
# Set the ownership of the data directory every single time.
# This ensures that even after a restart, the 'mysql' user can write to its data volume.
# This command must be OUTSIDE the if/else block.
chown -R mysql:mysql /var/lib/mysql

# Check if the database has already been initialized.
if [ -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB database already exists. Skipping initialization."
else
    # This block will now only run once and will have the correct permissions.
    echo "MariaDB database not found. Initializing..."
    
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    
    mariadbd --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
DROP DATABASE IF EXISTS test;
CREATE DATABASE \`${MYSQL_DATABASE}\`;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
EOF
fi

# Finally, start the MariaDB server in the foreground.
# It now has guaranteed permission to its data directory.
echo "Starting MariaDB server in foreground..."
exec mariadbd --user=mysql