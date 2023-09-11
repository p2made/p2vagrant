#!/bin/bash

# 02 Install Apache

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### #####"
echo "##### #####       Installing Apache"
echo "##### #####"
echo "##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### #####"

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

apt-get update

apt-get install -y apache2 apache2-bin apache2-data apache2-utils

yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/
yes | sudo cp /var/www/provision/html/index.html /var/www/html/index.htm

mv phpMyAdmin-$1-all-languages $3/html/phpmyadmin





a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

#rm -rf /var/www/html

systemctl restart apache2
#service apache2 restart
