# FROM wordpress:fpm-alpine


FROM debian:bookworm

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    php8.2 \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    php8.2-cli \
    php8.2-opcache \
    curl \
    mariadb-client \
    unzip \
    less \
    wget \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*


RUN echo "memory_limit = 256M" > /etc/php/8.2/fpm/conf.d/90-memlimit.ini

COPY ./conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
# Install mysql-client for mysqladmin

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

# Create web root
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

RUN mkdir -p /run/php


# Copy the entrypoint
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
