#!/bin/bash

openssl genrsa \
  -out /var/www/provision/ssl/example.tld.key \
  2048
openssl req -new -x509 \
  -key /var/www/provision/ssl/example.tld.key \
  -out /var/www/provision/ssl/example.tld.cert \
  -days 3650 \
  -subj /CN=example.tld

yes | cp /var/www/provision/vhosts/example.tld.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/example.tld.* /etc/apache2/sites-available/

a2ensite example.tld.conf

openssl genrsa \
  -out /var/www/provision/ssl/example1.tld.key \
  2048
openssl req -new -x509 \
  -key /var/www/provision/ssl/example1.tld.key \
  -out /var/www/provision/ssl/example1.tld.cert \
  -days 3650 \
  -subj /CN=example1.tld

yes | cp /var/www/provision/vhosts/example1.tld.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/example1.tld.* /etc/apache2/sites-available/

a2ensite example1.tld.conf

openssl genrsa \
  -out /var/www/provision/ssl/example2.tld.key \
  2048
openssl req -new -x509 \
  -key /var/www/provision/ssl/example2.tld.key \
  -out /var/www/provision/ssl/example2.tld.cert \
  -days 3650 \
  -subj /CN=example2.tld

yes | cp /var/www/provision/vhosts/example2.tld.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/example2.tld.* /etc/apache2/sites-available/

a2ensite example2.tld.conf

openssl genrsa \
  -out /var/www/provision/ssl/example3.tld.key \
  2048
openssl req -new -x509 \
  -key /var/www/provision/ssl/example3.tld.key \
  -out /var/www/provision/ssl/example3.tld.cert \
  -days 3650 \
  -subj /CN=example3.tld

yes | cp /var/www/provision/vhosts/example3.tld.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/example3.tld.* /etc/apache2/sites-available/

a2ensite example3.tld.conf

openssl genrsa \
  -out /var/www/provision/ssl/example4.tld.key \
  2048
openssl req -new -x509 \
  -key /var/www/provision/ssl/example4.tld.key \
  -out /var/www/provision/ssl/example4.tld.cert \
  -days 3650 \
  -subj /CN=example4.tld

yes | cp /var/www/provision/vhosts/example4.tld.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/example4.tld.* /etc/apache2/sites-available/

a2ensite example4.tld.conf

# Copy blocks for hosts ABOVE here

# Restart Apache...
sudo service apache2 restart
