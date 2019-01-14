# mariadb
A docker image that extends the official mariadb image [documentation](https://hub.docker.com/_/mariadb) to allow for:
- A cron job to backup to a remote Server
- A healthcheck ping following back to healthcheck.io to monitor the running of crons
- A filebeat with a named version number to send logs to logstash on the elk stack
- the running sql scripts on startup - even if the volume containing the database already exists

It expects the following Environmental variables to be set:

- WEEKLY_HEALTHCHECK: The URL or the healthcheck ping
- DAILY_HEALTHCHECK: The URL or the healthcheck ping
- BACKUP_PATH: The path on the backup server to the folder where backups should be stored
- SSH_DOMAIN: The domain that the backups will transfer to
- SSH_USER: The user that the backup script should connect to the backup server as
- SSH_KEY_PATH: The path to the SSH Private Key
- MYSQL_PASSWORD
- MYSQL_USER
- MYSQL_DATABASE
- STAGED_ENVIRONMENT: if this is set to anything other than production the backup won't run

And optionally

- INSTALL_SCRIPT - if this is set the image will attempt to run the named script that should have been loaded to `/var/lib/mysql/`
