#!bin/bash

if [ ! id -u "${FTP_USR}" > /dev/null ]; ther

    useradd -d /var/www/html "${FTP_USR}"
    echo "${FTP_USR}:${FTP_PASS}" | chpasswd
    echo "${FTP_USR}" >> /etc/vsftpd.userlist
    usermod -aG www-data "$FTP_USER"

fi

exec vsftpd /etc/vsftpd.conf