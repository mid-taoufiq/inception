#!/bin/bash

echo "entered mariadb script..."

chown -R mysql:mysql /var/lib/mysql

sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "creating mariadb database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    echo "FLUSH PRIVILEGES;
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;
    CREATE USER IF NOT EXISTS \`${MYSQL_USR}\`@'%' IDENTIFIED BY '${MYSQL_USR_PASS}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DB}\`.* TO \`${MYSQL_USR}\`@'%';
    FLUSH PRIVILEGES;" | mysqld --user=mysql --bootstrap

fi

echo "starting mariadb database..."
exec mysqld --user=mysql --console --port=${MARIADB_PORT}
