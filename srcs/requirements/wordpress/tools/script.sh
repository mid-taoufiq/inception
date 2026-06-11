#!/bin/bash

while mysqladmin ping -h mariadb -u ${MYSQLUSR} -p ${MYSQLUSEPASS} --silent; do
    echo "waiting for mariadb to connect..."
    sleep 1
done

if [ ! wp core is-installed --allow-root 2>/dev/null]; then

    echo "installing wordpress..."

    wp core download --allow-root
    wp config create --dbname=${MYSQLDB} --dbuser=${MYSQLUSR} --dbpass=${MYSQLUSEPASS} --dbhost=mariadb --allow-root
    wp core install --url=${WPURL} --title=${WPTITLE} --admin_user=${WPADMINUSER} --admin_password=${WPADMINPASS} --admin_email=${WPADMINEMAIL} --skip-email --allow-root
    wp user create ${WPUSR} ${WPUSREMAIL} --role=author --user_pass${WPUSRPASS} --allow-root

fi

echo "starting PHP-FPM engine..."
exec php-fpm7.4 -F
