#!/bin/sh

# 02 Install Apache

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "#####"
echo -e "#####       Installing Apache"
echo -e "#####"
echo -e "##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### #####\n\n"

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

apt-get update

apt-get -qy install apache2 apache2-bin apache2-data apache2-utils

yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/html/index.html /var/www/html/index.htm
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

systemctl restart apache2
