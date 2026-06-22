#!bin/bash

if ! id -u "${FTP_USR}" &> /dev/null; then

    useradd -d /var/www/html -s /bin/bash "${FTP_USR}"
    echo "${FTP_USR}:${FTP_PASS}" | chpasswd
    echo "${FTP_USR}" >> /etc/vsftpd.userlist
    chown -R "${FTP_USR}:${FTP_USR}" /var/www/html

fi

exec vsftpd /etc/vsftpd/vsftpd.conf
