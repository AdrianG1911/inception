FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y nginx openssl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

# Remove default site config
RUN rm -f /etc/nginx/sites-enabled/default /etc/nginx/conf.d/default.conf || true

# Make sure root dir exists with correct perms
RUN mkdir -p /var/www/html && \
	chown -R www-data:www-data /var/www/html && \
	chmod -R 755 /var/www
# Optional: run Nginx as www-data (like official nginx image)
RUN sed -i 's/user nginx;/user www-data;/' /etc/nginx/nginx.conf || true

COPY ./conf/wordpress.conf /etc/nginx/conf.d/
COPY ./tools/ssl.sh /ssl.sh

RUN chmod +x /ssl.sh

ENTRYPOINT ["/ssl.sh"]
CMD ["nginx", "-g", "daemon off;"]