#!/bin/bash

sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "/\[mysqld\]/a port = ${MARIADB_PORT}" /etc/mysql/mariadb.conf.d/50-server.cnf

echo "FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USR}\`@'%' IDENTIFIED BY '${MYSQL_USR_PASS}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO \`${MYSQL_USR}\`@'%';" | mysqld --user=mysql --bootstrap

exec mysqld --user=mysql --console --port=${MARIADB_PORT}
