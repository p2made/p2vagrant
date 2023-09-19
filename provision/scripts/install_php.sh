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

apt -qy install php$1

apt -qy install php$1-bcmath
apt -qy install php$1-bz2
apt -qy install php$1-cgi
apt -qy install php$1-curl
apt -qy install php$1-dom
apt -qy install php$1-fpm
apt -qy install php$1-gd
apt -qy install php$1-imagick
apt -qy install php$1-imap
apt -qy install php$1-intl
apt -qy install php$1-ldap
apt -qy install php$1-mbstring
apt -qy install php$1-mcrypt
apt -qy install php$1-mysql
apt -qy install php$1-pgsql
apt -qy install php$1-pspell
apt -qy install php$1-soap
apt -qy install php$1-xmlrpc
apt -qy install php$1-zip

apt -qy install php-pear
apt -qy install libapache2-mod-php$1

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$1/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$1/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$1/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$1/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$1/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$1/apache2/php.ini

cp /var/www/provision/html/phpinfo.php /var/www/html/phpinfo.php

a2enmod php$1
