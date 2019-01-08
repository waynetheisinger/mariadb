#!/bin/bash

#start wrt edit
echo "${INSTALL_SCRIPT}"

file="/var/lib/mysql/${INSTALL_SCRIPT}"

if [[ -f "$file" ]]
then
		#import to mysql
		mysql -u ${MYSQL_USER} -p${MYSQL_PASSWORD} ${MYSQL_DATABASE} < $file;
		echo "sql file has been run"
else
	echo "no file found"
fi

if [[ ${STAGED_ENVIRONMENT} == 'production' ]]
then
service cron start
sed -i "s:tmpdatabase:${MYSQL_DATABASE}:g" /tmp/cronjobs.txt
sed -i "s:tmpdbusername:${MYSQL_USER}:g" /tmp/cronjobs.txt
sed -i "s:tmpdbpassword:${MYSQL_PASSWORD}:g" /tmp/cronjobs.txt
sed -i "s:tmpsshkypath:${SSH_KEY_PATH}:g" /tmp/cronjobs.txt
sed -i "s:tmpsshuser:${SSH_USER}:g" /tmp/cronjobs.txt
sed -i "s:tmpsshdomain:${SSH_DOMAIN}:g" /tmp/cronjobs.txt
sed -i "s:tmpbackuppath:${BACKUP_PATH}:g" /tmp/cronjobs.txt
sed -i "s:tmpdailyhealthcheck:${DAILY_HEALTHCHECK}:g" /tmp/cronjobs.txt
sed -i "s:tmpweeklyhealthcheck:${WEEKLY_HEALTHCHECK}:g" /tmp/cronjobs.txt
crontab -u mysql /tmp/cronjobs.txt
fi

#end wrt edit

exec /docker-entrypoint.sh "$@"
