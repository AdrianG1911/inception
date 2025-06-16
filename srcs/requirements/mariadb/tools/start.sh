#!/bin/bash
set -e # Exit immediately if a command fails

# This is the correct, robust check. The 'mysql' directory is the core of MariaDB.
# If it exists, the database is already initialized and we should not touch it.
if [ -d "/var/lib/mysql/mysql" ]; then

    echo "MariaDB database already exists. Skipping initialization."

else
    # This 'else' block will only ever run ONCE in the entire lifetime of the volume.
    echo "MariaDB database not found. Initializing..."

    # Initialize the database directory. This creates the core system files and users.
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start the server in the background temporarily to configure it.
    mysqld_safe --nowatch &

    # Wait for the server to be ready for connections. This is more reliable than 'sleep'.
    until mysqladmin ping --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done

    # Use a "heredoc" to pass a series of SQL commands. It's cleaner and more reliable.
    # Note: Using IF NOT EXISTS is good practice for robustness.
    mariadb <<-EOF
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		DELETE FROM mysql.user WHERE User='';
		DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
		DROP DATABASE IF EXISTS test;
		DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
		FLUSH PRIVILEGES;
		CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
		CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
		FLUSH PRIVILEGES;
	EOF

    # Stop the temporary server using the new root password.
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

# Finally, start the MariaDB server in the foreground.
# 'exec' replaces the shell process, making MariaDB the main process (PID 1) of the container.
echo "Starting MariaDB server..."
exec mysqld_safe