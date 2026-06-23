#!/bin/bash

if ! id "${FTP_USR}" &> /dev/null ; then

    useradd -g www-data -d /var/www/html -s /bin/bash "${FTP_USR}"
    echo "${FTP_USR}:${FTP_PASS}" | chpasswd

fi

chown -R "${FTP_USR}:www-data" /var/www/html

exec vsftpd /etc/vsftpd/vsftpd.conf