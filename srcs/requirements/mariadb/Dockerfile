FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server

RUN rm -f /etc/mysql/mariadb.conf.d/50-server.cnf

RUN rm -rf /var/lib/mysql/*

COPY ./conf/my.cnf /etc/mysql/mariadb.conf.d/60-my.cnf
COPY ./tools/start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 3306
ENTRYPOINT ["/start.sh"]

#to login
#docker exec -t srcs-mariadb-1 bash
#mariadb -u root -p
#SHOW DATABASES;
#USE thing
#SHOW TABLES