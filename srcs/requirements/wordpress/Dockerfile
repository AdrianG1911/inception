# Changed to debian:bullseye
FROM debian:bullseye

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Debian Bullseye (PHP 7.4)
RUN apt-get update && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    php7.4-cli \
    php7.4-opcache \
    curl \
    mariadb-client \
    unzip \
    less \
    wget \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Update path for PHP 7.4 configuration
RUN echo "memory_limit = 256M" > /etc/php/7.4/fpm/conf.d/90-memlimit.ini

# Update path for PHP 7.4 configuration
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Install wp-cli (this is version-independent)
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