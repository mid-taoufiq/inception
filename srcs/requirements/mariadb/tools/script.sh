#!/bin/bash

chown -R mysql:mysql /val/lib/mysql

if [ ! -d "/var/lib/mysql/mysql"]; then
    echo "creating mariadb database..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
    mysql_safe &
    pid=$!
    while !mysqladmin ping --silent; do
        sleep 1
    done

    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY \`${MYSQLROOTPASS}\`;"
    mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQLDB}\`;"
    mysql -e "CREATE USER IF NOT EXISTS \`${MYSQLUSR}\`@'%' IDENTIFIED BY '${MYSQLUSEPASS}';"
    mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQLDB}\`.* TO \`${MYSQLUSR}\`@'%';"

    kill $pid
    wait $pid

    echo "mariadb database created!"
else
    echo "mariadb database already exists!"
fi

echo "mariadb service started!"
exec mysql_safe
