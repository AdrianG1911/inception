FROM nginx:latest

RUN rm /etc/nginx/conf.d/default.conf

COPY ./conf/wordpress.conf /etc/nginx/conf.d/
COPY ./tools/ssl.sh /ssl.sh

RUN chmod +x /ssl.sh

ENTRYPOINT ["/ssl.sh"]
CMD ["nginx", "-g", "daemon off;"]
