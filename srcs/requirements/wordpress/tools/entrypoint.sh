#!/bin/bash

set -e

echo "Waiting for MariaDB at $WORDPRESS_DB_HOST..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
  echo "MariaDB not ready yet..."
  sleep 1
done
echo "MariaDB is up!"

cd /var/www/html

# Download WordPress if not already downloaded
if [ ! -f wp-load.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root
fi

# Generate wp-config.php if it doesn't exist
if [ ! -f wp-config.php ]; then
    echo "Generating wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core install \
        --url=https://adrgutie.42.fr \
        --title="wordpress" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root

    chown -R www-data:www-data /var/www/html
fi

# Start PHP-FPM
exec php-fpm8.2 -F
