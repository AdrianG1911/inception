#!/bin/bash
mkdir -p /etc/nginx/ssl
openssl req -x509 -nodes -days 365 \
	-subj "/CN=localhost" \
	-newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt
