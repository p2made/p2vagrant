#!/bin/sh

# 05 Install PHP

# Variables...
# $1 - PHP_VERSION     = "8.2"

# Store the script name
SCRIPT_NAME="$(basename "$0")"

echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🚀 Installing PHP 🚀"
echo "Script Name: $0"
echo "Last Updated: 2023-01-19"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Update package lists
apt-get update

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/php

# Function to install packages with error handling
install_packages() {
	if ! apt-get -qy install "$@"; then
		echo "⚠️ Error: Failed to install packages 💥"
		exit 1
	fi
}

apt-get -qy install php$1

apt-get -qy install php$1-bcmath
apt-get -qy install php$1-bz2
apt-get -qy install php$1-cgi
apt-get -qy install php$1-cli
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

cp /var/www/provision/html/phpinfo.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

a2enmod php$1

service apache2 restart

echo ""
echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🏆 PHP Installed ‼️"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
















export DEBIAN_FRONTEND=noninteractive

# Function to copy files into place & set permissions
copy_files() {
	yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
	yes | cp /var/www/provision/html/index.htm /var/www/html/
	yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

	sudo chmod -R 755 /var/www/html/*
}

# Function to enable site, disable site, and enable modules with error handling
enable_disable_modules_sites() {
	if ! a2ensite "$1" && ! a2dissite "$2" && ! a2enmod "$3" && ! a2enmod ssl; then
		echo "⚠️ Error: Failed to configure Apache sites and modules 💥"
		exit 1
	fi
}

# Add repository for ondrej/apache2
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

# Call the function with the packages you want to install
install_packages \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

echo ""
echo "✅ Apache Installation: Packages installed successfully!"
echo ""

# Call the function to copy files
copy_files

# Call the function to enable/disable sites and enable modules (including ssl)
enable_disable_modules_sites local.conf 000-default rewrite

service apache2 restart

