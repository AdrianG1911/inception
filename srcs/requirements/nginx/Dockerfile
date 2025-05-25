#lastest stable verion of debian
FROM debian:bookworm-slim

#Install nginx and openssl
RUN apt-get update && \
apt-get install -y nginx openssl && \
rm -fr /var/lib/apt/lists/*

#Copy custom nginx config and SSL script
COPY conf/default /etc/nginx/sites-available/default
COPY tools/ssl.sh /tmp/ssl.sh

#Generate SSL certs
RUN bash /tmp/ssl.sh

#Serve a test HTML page
COPY html/ /var/www/html/

# run nginx in forground
CMD ["nginx", "-g", "daemon off;"]