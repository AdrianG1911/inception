#!/bin/bash


echo "Waiting for MariaDB at $WORDPRESS_DB_HOST..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
  echo "MariaDB not ready yet..."
  sleep 1
done
echo "MariaDB is up!"

# Wait until MariaDB is ready
echo "Waiting for MariaDB..."
while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" --silent; do
    sleep 1
done

# Check if WordPress is already installed
if ! wp core is-installed --allow-root; then
    echo "Installing WordPress..."
    wp core download --allow-root
    ls -la /var/www/html
    wp config create --dbname=$WORDPRESS_DB_NAME \
                     --dbuser=$WORDPRESS_DB_USER \
                     --dbpass=$WORDPRESS_DB_PASSWORD \
                     --dbhost=$WORDPRESS_DB_HOST \
                     --allow-root
    wp core install \
                    --url=https://adrgutie.42.fr \
                    --title="wordpress" \
                    --admin_user=wp_user \
                    --admin_password=wp_pass \
                    --admin_email=fake@email.com \
                    --allow-root
    
    # wp core install --url=https://adrgutie.42.fr \
    #                 --title="wordpress" \
    #                 --admin_user=$WP_ADMIN_USER \
    #                 --admin_password=$WP_ADMIN_PASS \
    #                 --admin_email=$WP_ADMIN_EMAIL \
    #                 --allow-root
    # wp user create $WP_USER $WP_USER_EMAIL \
    #                --role=author \
    #                --user_pass=$WP_USER_PASS \
    #                --allow-root
fi

exec php-fpm -F
