# FROM wordpress:fpm-alpine


FROM wordpress:php8.2-fpm


RUN echo "memory_limit = 256M" > /usr/local/etc/php/conf.d/memlimit.ini
# Install mysql-client for mysqladmin
RUN apt-get update && apt-get install -y default-mysql-client && rm -rf /var/lib/apt/lists/*

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Copy the entrypoint
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# Expose port only if accessed directly (usually accessed via nginx)
EXPOSE 9000
