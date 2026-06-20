#!bin/bash

sed -i "s/127.0.0.1 -::1/0.0.0.0/g" /etc/redis/redis.conf
sed -i "s/protected-mode yes/protected-mode no/g" /etc/redis/redis.conf

exec redis-server /etc/redis/redis.conf
