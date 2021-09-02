#!/bin/bash

# For each host...

openssl req -x509 \
  -newkey rsa:2048 \
  -sha256 \
  -days 3650 \
  -nodes \
  -keyout /var/www/provision/ssl/p2m.key \
  -out /var/www/provision/ssl/p2m.crt \
  -subj "/CN=p2m"

yes | cp /var/www/provision/vhosts/p2m.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/p2m.* /etc/apache2/sites-available/

a2ensite p2m.conf

openssl req -x509 \
  -newkey rsa:2048 \
  -sha256 \
  -days 3650 \
  -nodes \
  -keyout /var/www/provision/ssl/phpmyadmin.p2m.key \
  -out /var/www/provision/ssl/phpmyadmin.p2m.crt \
  -subj "/CN=phpmyadmin.p2m"

yes | cp /var/www/provision/vhosts/phpmyadmin.p2m.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/phpmyadmin.p2m.* /etc/apache2/sites-available/

a2ensite phpmyadmin.p2m.conf

# Copy blocks for hosts ABOVE here

# Restart Apache...
sudo service apache2 restart
