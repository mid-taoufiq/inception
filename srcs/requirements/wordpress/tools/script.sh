#!/bin/bash

if [ ! -f "/var/www/html/wp-config.php" ]; then

    wp core download --allow-root --path=/var/www/html

    wp config create \
    --dbname=${MYSQL_DB} \
    --dbuser=${MYSQL_USR} \
    --dbpass=${MYSQL_USR_PASS} \
    --dbhost=mariadb:${MARIADB_PORT} \
    --allow-root \
    --path=/var/www/html

    wp core install \
    --url=https://${WP_URL} \
    --title=${WP_TITLE} \
    --admin_user=${WP_ADMIN} \
    --admin_password=${WP_ADMIN_PASS} \
    --admin_email=${WP_ADMIN_EMAIL} \
    --skip-email \
    --allow-root \
    --path=/var/www/html

    wp user create \
    ${WP_USR} ${WP_USR_EMAIL} \
    --role=author \
    --user_pass=${WP_USR_PASS} \
    --allow-root \
    --path=/var/www/html

    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root

fi

chown -R www-data:www-data /var/www/html

exec php-fpm8.2 -F
