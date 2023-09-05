#!/bin/bash

# 02 Install Apache

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

apt-get update
apt-get install -y apache2

yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

a2ensite local.conf
a2dissite 000-default

a2enmod rewrite
a2enmod ssl

#rm -rf /var/www/html

#service apache2 restart
systemctl restart apache2
