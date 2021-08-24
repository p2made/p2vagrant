#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

sudo apt-get update
sudo apt-get install -y apache2

yes | cp /var/www/provision/config/apache/vhosts/local.conf /etc/apache2/sites-available/
#yes | cp /var/www/provision/config/ssl/* /etc/apache2/sites-available/





#!/bin/bash

apt-get update
apt-get install -y apache2

# Copy the vhost config file
cp ./provision/config/apache/vhosts/mytestproject.local.com.conf /etc/apache2/sites-available/mytestproject.local.com.conf

# Disable the default vhost file
a2dissite 000-default

# Enable our custom vhost file
a2ensite mytestproject.local.com.conf

# Restart for the changes to take effect
service apache2 restart




#!/bin/bash

apt-get update
apt-get install -y apache2

a2ensite local.conf
a2dissite 000-default

a2enmod rewrite
sudo service apache2 restart

rm -rf /var/www/html

sudo a2enmod ssl
sudo service apache2 restart
