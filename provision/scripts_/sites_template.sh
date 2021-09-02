#!/bin/bash

# For each host...

openssl req -x509 \
  -newkey rsa:2048 \
  -sha256 \
  -days 3650 \
  -nodes \
  -keyout /var/www/provision/ssl/_hostname_.key \
  -out /var/www/provision/ssl/_hostname_.crt \
  -subj "/CN=_hostname_"

yes | cp /var/www/provision/vhosts/_hostname_.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/_hostname_.* /etc/apache2/sites-available/

a2ensite _hostname_.conf

# Restart Apache...
sudo service apache2 restart
