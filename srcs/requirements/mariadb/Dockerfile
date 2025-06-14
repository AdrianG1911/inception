FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server

COPY ./tools/start.sh /start.sh
RUN chmod +x /start.sh

RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306
ENTRYPOINT ["/start.sh"]
