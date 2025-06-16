FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server

# This is the critical fix.
# The 'apt-get install' command above creates a default database.
# We must remove it so our entrypoint script can create a fresh one
# with the correct users and passwords from the .env file.
RUN rm -rf /var/lib/mysql/*

# Your existing configuration and script setup remains the same.
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