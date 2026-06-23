#!/bin/bash

if ! id "${FTP_USR}" ; then
	echo "gg"
    useradd -g www-data -d /var/www/html -s /bin/bash "${FTP_USR}"
    echo "elmiki"
    echo "${FTP_USR}:${FTP_PASS}" | chpasswd
    echo "cc"

fi
echo "mm"
chown -R "${FTP_USR}:www-data" /var/www/html
echo "bb"
exec vsftpd /etc/vsftpd/vsftpd.conf
echo "tt"
