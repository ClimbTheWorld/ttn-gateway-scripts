#!/bin/bash
#
# uploading logfiles to ftp - ex. using as a cronjob
#
# Lukas, ASMON, 2.3.2017
#
HOST='<host>'
USER='<user>'
PASSWD='<password>'
LOGFILE='path/*.log'
cd /var/log
ftp -n -v $HOST <<EOT
ascii
user $USER $PASSWD
prompt
mput $LOGFILE
bye
EOT
