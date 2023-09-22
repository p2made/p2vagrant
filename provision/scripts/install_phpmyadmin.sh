#!/bin/sh

# 05 Install phpMyAdmin

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "#####"
echo -e "#####       Installing phpMyAdmin "$1
echo -e "#####"
echo -e "##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### #####\n\n"

# PMA_VERSION         = "5.2.1"               | $1
# PMA_PASSWORD        = "PM4Passw0rd"         | $2
# REMOTE_FOLDER       = "/var/www"            | $3

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:phpmyadmin/ppa

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get -qy install phpmyadmin

rm -rf /usr/share/phpmyadmin

cp -r /var/www/provision/html/phpMyAdmin /var/www/html/phpMyAdmin

sudo chmod -R 755 /var/www/html/phpmyadmin

sudo phpenmod mbstring
service apache2 restart
