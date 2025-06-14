#!/bin/bash

SSL_DIR=/etc/nginx/ssl
CRT_FILE=$SSL_DIR/nginx.crt
KEY_FILE=$SSL_DIR/nginx.key

mkdir -p "$SSL_DIR"

if [ ! -f "$CRT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
  echo "Generating self-signed SSL cert..."
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout "$KEY_FILE" \
    -out "$CRT_FILE" \
    -subj "/CN=adrgutie.42.fr" \
    -addext "subjectAltName=DNS:adrgutie.42.fr"
fi

exec nginx -g "daemon off;"
