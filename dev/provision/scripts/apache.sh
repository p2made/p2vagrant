#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

sudo apt-get update
sudo apt-get install -y apache2

# Copy the vhost config file
yes | cp ./provision/config/apache/vhosts/local.conf /etc/apache2/sites-available/
#yes | cp /var/www/provision/config/ssl/* /etc/apache2/sites-available/

# Disable the default vhost file
a2dissite 000-default

# Enable our custom vhost file
a2ensite mytestproject.local.com.conf

# Restart for the changes to take effect
service apache2 restart

# Remove Ubuntu /html folder
rm -rf /var/www/html

# Enable SSL
sudo a2enmod ssl

# Restart for the changes to take effect
sudo service apache2 restart
