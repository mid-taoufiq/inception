#!/bin/bash

chown -R mysql:mysql /var/lib/mysql

sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

if [ ! -d "/var/lib/mysql/mysql"]; then

    echo "creating mariadb database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    while !mysqladmin ping --silent; do
        sleep 1
    done

    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQLROOTPASS}';
    CREATE DATABASE IF NOT EXISTS \`${MYSQLDB}\`;
    CREATE USER IF NOT EXISTS \`${MYSQLUSR}\`@'%' IDENTIFIED BY '${MYSQLUSEPASS}';
    GRANT ALL PRIVILEGES ON \`${MYSQLDB}\`.* TO \`${MYSQLUSR}\`@'%';" | mysqld --user=mysql --bootstrap

fi

echo "starting mariadb database..."
exec mysqld --user=mysql --console
