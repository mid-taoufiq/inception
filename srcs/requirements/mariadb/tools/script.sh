#!/bin/bash

set -e

echo "entered mariadb script..."

sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "mysql not installed, installing mysql now..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

fi

echo "creating mariadb database..."

echo "FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USR}\`@'%' IDENTIFIED BY '${MYSQL_USR_PASS}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO \`${MYSQL_USR}\`@'%';" | mysqld --user=mysql --bootstrap

echo "starting mariadb database..."
exec mysqld --user=mysql --console --port=${MARIADB_PORT}
