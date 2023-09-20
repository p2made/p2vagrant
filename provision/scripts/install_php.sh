#!/bin/sh

# 04 Install PHP (& Composer)

echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo -e "#####"
echo -e "#####       Installing PHP "$1" (& Composer)"
echo -e "#####"
echo -e "##### ##### ##### ##### ##### #####"
echo -e "##### ##### ##### ##### #####\n\n"

# PHP_VERSION         = "8.2"                 | $1

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/php

apt-get -qy install php$1

apt-get -qy install php$1-{bcmath,bz2,cgi,curl,dom,fpm,gd,imagick,imap,intl,ldap,mbstring,mcrypt,mysql,pgsql,pspell,soap,xmlrpc,zip}

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
service apache2 restart
