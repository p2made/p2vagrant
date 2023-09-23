#!/bin/sh

# 06 Install Composer

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Installing __item__                             #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

cd /tmp
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

php composer-setup.php
rm composer-setup.php

sudo mv composer.phar /usr/local/bin/composer
composer self-update

composer
