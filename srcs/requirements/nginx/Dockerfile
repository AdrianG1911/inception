# #lastest stable verion of debian
# FROM debian:bookworm-slim

# #Install nginx and openssl
# #RUN apt-get update && \
# #apt-get install -y nginx openssl && \
# #rm -fr /var/lib/apt/lists/*
# RUN apt-get update && apt-get install -y nginx
# RUN rm /etc/nginx/conf.d/default.conf

# #Copy custom nginx config and SSL script
# COPY conf/wordpress.conf /etc/nginx/conf/wordpress.conf
# COPY tools/ssl.sh /tmp/ssl.sh

# #Generate SSL certs
# RUN bash /tmp/ssl.sh

# #Serve a test HTML page
# COPY html/ /var/www/html/

# # run nginx in forground
# CMD ["nginx", "-g", "daemon off;"]
# Use official nginx image with pre-configured paths
FROM nginx:latest

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy custom config (make sure this file exists in build context)
COPY ./conf/wordpress.conf /etc/nginx/conf.d/

# Copy SSL files (optional: if you're handling this externally via mounted volume, skip)

COPY ./tools/ssl.sh /ssl.sh
# RUN bash /tmp/ssl.sh
RUN chmod +x /ssl.sh && /ssl.sh

CMD ["nginx", "-g", "daemon off;"]
