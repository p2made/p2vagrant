#!/bin/bash

sed -i.bak 's/^[^#]*BBB/#&/' /etc/ssl/openssl.cnf

if [ ! -f /var/www/provision/apache/ssl/local.key ]; then
  openssl req -x509 \
    -newkey rsa:4096 \
    -sha256 \
    -days 730 \
    -nodes \
    -keyout /var/www/provision/apache/ssl/local.key \
    -out /var/www/provision/apache/ssl/local.crt \
    -subj "/CN=$1" \
    -addext "subjectAltName=DNS:$1,DNS:*.$1,IP:10.0.0.1"
fi
