#!/bin/bash

# For each host...

#sed -i.bak 's/^[^#]*BBB/#&/' /etc/ssl/_hostname_.cnf

if [ ! -f /var/www/provision/ssl/_hostname_.key ]; then
  openssl req -x509 \
    -newkey rsa:2048 \
    -sha256 \
    -days 730 \
    -nodes \
    -keyout /var/www/provision/ssl/_hostname_.key \
    -out /var/www/provision/ssl/_hostname_.crt \
    -subj "/CN=_hostname_" \
    -addext "subjectAltName=DNS:_hostname_,DNS:*._hostname_,IP:10.0.0.1"
fi

yes | cp /var/www/provision/vhosts/_hostname_.conf /etc/apache2/sites-available/

a2ensite _hostname_.conf

# Restart Apache...
sudo service apache2 restart


openssl genrsa \
  -out /var/www/provision/ssl/_hostname_.key \
  2048
openssl req -new -x509 \
  -key /var/www/provision/ssl/_hostname_.key \
  -out /var/www/provision/ssl/_hostname_.cert \
  -days 3650 \
  -subj /CN=_hostname_
