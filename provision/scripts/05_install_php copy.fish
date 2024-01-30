#!/bin/fish

# 05 Install PHP (with Composer)

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing PHP (with Composer 🙃) 🚀"
echo "🇺🇿    📜 Script Name:  05_install_php.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-28"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Arguments...
# 1 - PHP_VERSION     = "8.3"

set PHP_VERSION $argv[1]

set PACKAGE_LIST \

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Function for error handling
# Usage: handle_error "Error message"

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]

# Function to update package lists
# Usage: update_package_lists

# Function to install packages with error handling
# Usage: install_packages $package_list

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Add repository for ondrej/php
sudo LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/php


# Update package lists & install packages
sudo apt -qy install php8.3

libapache2-mod-php8.3
php-common
php8.3-cli
php8.3-common
php8.3-opcache
php8.3-readline

sudo apt -qy install \
	php8.3-apcu \
	php8.3-bcmath \
	php8.3-bz2 \
	php8.3-cgi \
	php8.3-curl

sudo apt -qy install \
	php8.3-decimal \
	php8.3-dom \
	php8.3-enchant \
	php8.3-fpm \
	php8.3-gd \
	php8.3-gmp \
	php8.3-gnupg

sudo apt -qy install \
	php8.3-imagick \
	php8.3-imap \
	php8.3-intl \
	php8.3-ldap \
	php8.3-mbstring \
	php8.3-memcache \
	php8.3-mysql

sudo apt -qy install \
	php8.3-oauth \
	php8.3-opcache \
	php8.3-pcov \
	php8.3-pspell \
	php8.3-psr \
	php8.3-readline \
	php8.3-redis

sudo apt -qy install \
	php8.3-soap \
	php8.3-sqlite3 \
	php8.3-tidy \
	php8.3-uuid \
	php8.3-xdebug \
	php8.3-xmlrpc \
	php8.3-xsl \
	php8.3-zip \
	php8.3-zstd

sudo apt -qy install \
	php-composer-ca-bundle \
	php-date \
	php-db \
	php-db-dataobject \
	php-deepcopy \
	php-dompdf \
	php-font-lib \
	php-google-recaptcha

sudo apt -qy install \
	php-json \
	php-nikic-fast-route \
	php-pear \
	php-phpmyadmin-motranslator \
	php-phpmyadmin-shapefile \
	php-phpmyadmin-sql-parser

sudo apt -qy install \
	php-twig \
	php-twig-extensions \
	php-twig-html-extra \
	php-twig-intl-extra \
	php-webmozart-assert

sudo apt-get purge php7.1-*

please remind me of the shorthand syntax for 'apt install', so that instead of 'apt -qy install php-abc php-def php-ghi' i use something like 'apt -qy install php-{something in here}'




sudo apt -qy install php

	php \

aspell
aspell-en
dictionaries-common
emacsen-common
enchant-2
hp8.3-decimal
hunspell-en-us
libaspell15
libenchant-2-2
libgd3
libhunspell-1.7-0
libjbig0
libjpeg-turbo8
libjpeg8
libtiff5
libwebp6 p

aspell-doc
hunspell
libenchant-2-voikko
libgd-tools php-pear
openoffice.org-core
openoffice.org-hunspell
spellutils
wordlist

The following additional packages will be installed:
  fonts-droid-fallback fonts-noto-mono fonts-urw-base35 ghostscript gsfonts imagemagick-6-common libavahi-client3 libavahi-common-data libavahi-common3
  libc-client2007e libcups2 libfftw3-double3 libgs9 libgs9-common libidn11 libijs-0.35 libjbig2dec0 liblcms2-2 liblqr-1-0 libmagickcore-6.q16-6
  libmagickwand-6.q16-6 libonig5 libopenjp2-7 libpaper-utils libpaper1 libwebpmux3 mlock poppler-data
Suggested packages:
  fonts-noto fonts-freefont-otf | fonts-freefont-ttf fonts-texgyre ghostscript-x uw-mailutils cups-common libfftw3-bin libfftw3-dev liblcms2-utils
  libmagickcore-6.q16-6-extra memcached poppler-utils fonts-japanese-mincho | fonts-ipafont-mincho fonts-japanese-gothic | fonts-ipafont-gothic
  fonts-arphic-ukai fonts-arphic-uming fonts-nanum
The following NEW packages will be installed:
  fonts-droid-fallback fonts-noto-mono fonts-urw-base35 ghostscript gsfonts imagemagick-6-common libavahi-client3 libavahi-common-data libavahi-common3
  libc-client2007e libcups2 libfftw3-double3 libgs9 libgs9-common libidn11 libijs-0.35 libjbig2dec0 liblcms2-2 liblqr-1-0 libmagickcore-6.q16-6
  libmagickwand-6.q16-6 libonig5 libopenjp2-7 libpaper-utils libpaper1 libwebpmux3 mlock php8.3-imagick php8.3-imap php8.3-intl php8.3-ldap php8.3-mbstring
  php8.3-memcache php8.3-mysql poppler-data

The following additional packages will be installed:
  php8.3-igbinary
Suggested packages:
  redis-server
The following NEW packages will be installed:
  php8.3-igbinary php8.3-oauth php8.3-pcov php8.3-pspell php8.3-psr php8.3-redis

The following additional packages will be installed:
  libtidy5deb1 libxmlrpc-epi0 libzip4
The following NEW packages will be installed:
  libtidy5deb1 libxmlrpc-epi0 libzip4 php8.3-soap php8.3-sqlite3 php8.3-tidy php8.3-uuid php8.3-xdebug php8.3-xmlrpc php8.3-xsl php8.3-zip php8.3-zstd

The following additional packages will be installed:
  fonts-dejavu fonts-dejavu-extra php-mdb2 php-pear php-validate sdop
Suggested packages:
  php-tcpdf php-mdb2-driver-fbsql php-mdb2-driver-ibase php-mdb2-driver-mssql php-mdb2-driver-mysql php-mdb2-driver-mysqli php-mdb2-driver-oci8
  php-mdb2-driver-odbc php-mdb2-driver-pgsql php-mdb2-driver-querysim php-mdb2-driver-sqlite php-mdb2-driver-sqlsrv
Recommended packages:
  php-net-idna
The following NEW packages will be installed:
  fonts-dejavu fonts-dejavu-extra php-composer-ca-bundle php-date php-db php-db-dataobject php-deepcopy php-dompdf php-font-lib php-google-recaptcha php-mdb2
  php-pear php-validate sdop

The following additional packages will be installed:
  php-psr-cache php-psr-container php-psr-log php-symfony-cache php-symfony-cache-contracts php-symfony-expression-language php-symfony-polyfill-php80
  php-symfony-service-contracts php-symfony-var-exporter
Suggested packages:
  php-dbase php-symfony-service-implementation
The following NEW packages will be installed:
  php-json php-nikic-fast-route php-phpmyadmin-motranslator php-phpmyadmin-shapefile php-phpmyadmin-sql-parser php-psr-cache php-psr-container php-psr-log
  php-symfony-cache php-symfony-cache-contracts php-symfony-expression-language php-symfony-polyfill-php80 php-symfony-service-contracts
  php-symfony-var-exporter

The following additional packages will be installed:
  icc-profiles-free libmcrypt4 php7.1-cli php7.1-common php7.1-json php7.1-mcrypt php7.1-opcache php7.1-phpdbg php7.1-readline php7.1-sodium
Suggested packages:
  libmcrypt-dev mcrypt
The following NEW packages will be installed:
  icc-profiles-free libmcrypt4 php-psr-http-factory php-psr-http-message php-sodium php-tcpdf php7.1-cli php7.1-common php7.1-json php7.1-mcrypt
  php7.1-opcache php7.1-phpdbg php7.1-readline php7.1-sodium

The following additional packages will be installed:
  php-symfony-intl php-symfony-mime
Suggested packages:
  php-twig-doc php-symfony-translation
The following NEW packages will be installed:
  php-symfony-intl php-symfony-mime php-twig php-twig-extensions php-twig-html-extra php-twig-intl-extra php-webmozart-assert

vagrant@vagrant ~> php -v
PHP 8.3.2-1+ubuntu20.04.1+deb.sury.org+1 (cli) (built: Jan 20 2024 14:16:18) (NTS)
Copyright (c) The PHP Group
Zend Engine v4.3.2, Copyright (c) Zend Technologies
    with Zend OPcache v8.3.2-1+ubuntu20.04.1+deb.sury.org+1, Copyright (c), by Zend Technologies
    with Xdebug v3.3.1, Copyright (c) 2002-2023, by Derick Rethans
vagrant@vagrant ~>


sed -i 's/max_execution_time = .*/max_execution_time = 60/'         /etc/php/8.3/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/'                  /etc/php/8.3/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/'       /etc/php/8.3/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/'                   /etc/php/8.3/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/'                 /etc/php/8.3/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/8.3/apache2/php.ini

cp /var/www/provision/html/phpinfo.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

a2enmod "php8.3"

# Restart Apache to apply changes
systemctl restart apache2

announce_success "PHP Installed Successfully! ✅"

if not curl -sS https://getcomposer.org/installer | \
	sudo php -- --install-dir=/usr/local/bin --filename=composer
	handle_error "Failed to install Composer"
end

announce_success "Composer Installed Successfully! ✅"

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 PHP Installed (with Composer) ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"


	php8.3 \
	php8.3-common \
	php8.3-apcu \
	php8.3-bcmath \
	php8.3-bz2 \
	php8.3-cgi \
	php8.3-cli \
	php8.3-curl \
	php8.3-decimal \
	php8.3-dom \
	php8.3-enchant \
	php8.3-fpm \
	php8.3-gd \
	php8.3-gmp \
	php8.3-gnupg \
	php8.3-imagick \
	php8.3-imap \
	php8.3-intl \
	php8.3-ldap \
	php8.3-mbstring \
	php8.3-memcache \
	php8.3-mysql \
	php8.3-oauth \
	php8.3-opcache \
	php8.3-pcov \
	php8.3-pspell \
	php8.3-psr \
	php8.3-readline \
	php8.3-redis \
	php8.3-soap \
	php8.3-sqlite3 \
	php8.3-tidy \
	php8.3-uuid \
	php8.3-xdebug \
	php8.3-xml \
	php8.3-xmlrpc \
	php8.3-xsl \
	php8.3-zip \
	php8.3-zstd \
	php \
	php-composer-ca-bundle \
	php-date \
	php-db \
	php-db-dataobject \
	php-deepcopy \
	php-dompdf \
	php-font-lib \
	php-google-recaptcha \
	php-json \
	php-nikic-fast-route \
	php-pear \
	php-phpmyadmin-motranslator \
	php-phpmyadmin-shapefile \
	php-phpmyadmin-sql-parser \
	php-psr-cache \
	php-psr-http-factory \
	php-psr-http-message \
	php-psr-log \
	php-sodium \
	php-tcpdf \
	php-twig \
	php-twig-extensions \
	php-twig-html-extra \
	php-twig-intl-extra \
	php-webmozart-assert \
	libapache2-mod-php8.3
