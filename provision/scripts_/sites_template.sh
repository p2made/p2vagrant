#!/bin/bash

# For each host...

# Copy this block to sites.sh
# Replace _hostname_ with actual development host name

openssl genrsa \
  -out /var/www/provision/ssl/_hostname_.key \
  2048
openssl req -new -x509 \
  -key /var/www/provision/ssl/_hostname_.key \
  -out /var/www/provision/ssl/_hostname_.cert \
  -days 3650 \
  -subj /CN=_hostname_

yes | cp /var/www/provision/vhosts/_hostname_.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/_hostname_.* /etc/apache2/sites-available/

a2ensite _hostname_.conf

# / end for each host

# Restart Apache...
sudo service apache2 restart
