FROM mariadb:10
MAINTAINER Wayne Theisinger <wayne@intacart.co.uk>

RUN apt-get update \
  && apt-get install -y \
    cron \
    curl \
    openssh-client && \
    apt-get clean

ARG INSTALL_SCRIPT=placeholder
ENV INSTALL_SCRIPT="${INSTALL_SCRIPT}"

COPY conf/config-file.cnf /etc/mysql/conf.d/config-file.cnf

RUN install -d -o mysql -g mysql -m 700 /home/mysql/.ssh/ && \
ssh-keyscan 54.38.47.237 > /home/mysql/.ssh/known_hosts

COPY conf/cronjobs.txt /tmp/cronjobs.txt


COPY docker-entrypoint-wrapper.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint-wrapper.sh
RUN ln -s /usr/local/bin/docker-entrypoint-wrapper.sh / # backwards compat
ENTRYPOINT ["/docker-entrypoint-wrapper.sh"]

EXPOSE 3306
CMD ["mysqld"]
