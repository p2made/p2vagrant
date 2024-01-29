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

# Variables...
# 1 - PHP_VERSION     = "8.3"

set PHP_VERSION $argv[1]

set PACKAGE_LIST \
	php$PHP_VERSION \
	php$PHP_VERSION-common \
	php$PHP_VERSION-apcu \
	php$PHP_VERSION-bcmath \
	php$PHP_VERSION-bz2 \
	php$PHP_VERSION-cgi \
	php$PHP_VERSION-cli \
	php$PHP_VERSION-curl \
	php$PHP_VERSION-decimal \
	php$PHP_VERSION-dom \
	php$PHP_VERSION-enchant \
	php$PHP_VERSION-fpm \
	php$PHP_VERSION-gd \
	php$PHP_VERSION-gmp \
	php$PHP_VERSION-gnupg \
	php$PHP_VERSION-imagick \
	php$PHP_VERSION-imap \
	php$PHP_VERSION-intl \
	php$PHP_VERSION-ldap \
	php$PHP_VERSION-mbstring \
	php$PHP_VERSION-memcache \
	php$PHP_VERSION-mysql \
	php$PHP_VERSION-oauth \
	php$PHP_VERSION-opcache \
	php$PHP_VERSION-pcov \
	php$PHP_VERSION-pspell \
	php$PHP_VERSION-psr \
	php$PHP_VERSION-readline \
	php$PHP_VERSION-redis \
	php$PHP_VERSION-soap \
	php$PHP_VERSION-sqlite3 \
	php$PHP_VERSION-tidy \
	php$PHP_VERSION-uuid \
	php$PHP_VERSION-xdebug \
	php$PHP_VERSION-xml \
	php$PHP_VERSION-xmlrpc \
	php$PHP_VERSION-xsl \
	php$PHP_VERSION-zip \
	php$PHP_VERSION-zstd \
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
	libapache2-mod-php$PHP_VERSION

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
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/php

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

sed -i 's/max_execution_time = .*/max_execution_time = 60/' "/etc/php/$PHP_VERSION/apache2/php.ini"
sed -i 's/post_max_size = .*/post_max_size = 64M/' "/etc/php/$PHP_VERSION/apache2/php.ini"
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' "/etc/php/$PHP_VERSION/apache2/php.ini"
sed -i 's/memory_limit = .*/memory_limit = 512M/' "/etc/php/$PHP_VERSION/apache2/php.ini"
sed -i 's/display_errors = .*/display_errors = on/' "/etc/php/$PHP_VERSION/apache2/php.ini"
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' "/etc/php/$PHP_VERSION/apache2/php.ini"

cp /var/www/provision/html/phpinfo.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

a2enmod "php$PHP_VERSION"

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
