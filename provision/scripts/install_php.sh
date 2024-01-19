#!/bin/sh

# 06 Install PHP

# Variables...
# $1 - PHP_VERSION     = "8.2"

echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🚀 Installing PHP 🚀"
echo "Script Name:  install_php.sh"
echo "Last Updated: 2024-01-20"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Add repository for ondrej/php
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/php

# Function to update package lists
echo "🔄 Updating package lists 🔄"
if ! apt-get -q update; then
	handle_error "⚠️ Failed to update package lists"
fi

# Function to install packages with error handling
install_packages() {
	if ! apt-get -qy install "$@"; then
		echo "⚠️ Error: Failed to install packages 💥"
		exit 1
	fi
}

# Call the function with the packages you want to install
install_packages \
	php$1 \
	php$1-common \
	php$1-mysql \
	php$1-bcmath \
	php$1-bz2 \
	php$1-cgi \
	php$1-cli \
	php$1-curl \
	php$1-dom \
	php$1-fpm \
	php$1-gd \
	php$1-imagick \
	php$1-imap \
	php$1-intl \
	php$1-ldap \
	php$1-mbstring \
	php$1-mcrypt \
	php$1-pgsql \
	php$1-pspell \
	php$1-soap \
	php$1-xmlrpc \
	php$1-zip \
	php-apcu \
	php-bacon-qr-code \
	php-code-lts-u2f-php-server \
	php-composer-ca-bundle \
	php-dbase \
	php-fig-http-message-util \
	php-gd2 \
	php-getallheaders \
	php-google-recaptcha \
	php-mariadb-mysql-kbs \
	php-mysql \
	php-nikic-fast-route \
	php-pear \
	php-phpmyadmin-motranslator \
	php-phpmyadmin-shapefile \
	php-phpmyadmin-sql-parser \
	php-pragmarx-google2fa-qrcode \
	php-psr-cache \
	php-psr-container \
	php-psr-http-factory \
	php-psr-http-message \
	php-psr-log \
	php-recode \
	php-slim-psr7 \
	php-sodium \
	php-symfony-cache \
	php-symfony-cache-contracts \
	php-symfony-config \
	php-symfony-dependency-injection \
	php-symfony-expression-language \
	php-symfony-filesystem \
	php-symfony-finder \
	php-symfony-polyfill-php80 \
	php-symfony-proxy-manager-bridge \
	php-symfony-service-contracts \
	php-symfony-var-exporter \
	php-symfony-yaml \
	php-tcpdf \
	php-twig \
	php-twig-doc \
	php-twig-i18n-extension \
	php-web-auth-webauthn-lib \
	php-webmozart-assert \
	libapache2-mod-php$1

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$1/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$1/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$1/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$1/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$1/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$1/apache2/php.ini

cp /var/www/provision/html/phpinfo.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

a2enmod php$1

service apache2 restart

echo ""
echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🏆 PHP Installed ‼️"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
