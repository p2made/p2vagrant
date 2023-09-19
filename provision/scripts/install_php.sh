#!/bin/sh

# 03 Install PHP 8.2

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "#####"
echo -e "#####       Installing PHP "$1
echo -e "#####"
echo -e "##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### #####\n\n"

# PHP_VERSION         = "8.2"                 | $1

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/php

apt-get -qy install php$1

apt-get -qy install php$1-bcmath
apt-get -qy install php$1-bz2
apt-get -qy install php$1-cgi
apt-get -qy install php$1-curl
apt-get -qy install php$1-dom
apt-get -qy install php$1-fpm
apt-get -qy install php$1-gd
apt-get -qy install php$1-imagick
apt-get -qy install php$1-imap
apt-get -qy install php$1-intl
apt-get -qy install php$1-ldap
apt-get -qy install php$1-mbstring
apt-get -qy install php$1-mcrypt
apt-get -qy install php$1-mysql
apt-get -qy install php$1-pgsql
apt-get -qy install php$1-pspell
apt-get -qy install php$1-soap
apt-get -qy install php$1-xmlrpc
apt-get -qy install php$1-zip

apt-get -qy install php-pear
apt-get -qy install libapache2-mod-php$1

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$1/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$1/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$1/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$1/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$1/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$1/apache2/php.ini

cp /var/www/provision/html/phpinfo.php /var/www/html/phpinfo.php

a2enmod php$1
