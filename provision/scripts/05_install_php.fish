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
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - REMOTE_FOLDER   = "/var/www"
# 2 - PHP_VERSION     = "8.3"

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

# Script variables...

# Function to set path variables based on the passed path root
# Usage: set_path_variables /var/www - usually REMOTE_FOLDER from the Vagrantfile
# VM_FOLDER $argv[1]
# PROVISION_FOLDER $VM_FOLDER/provision
# HTML_FOLDER      $PROVISION_FOLDER/html
# SSL_FOLDER       $PROVISION_FOLDER/ssl
# VHOSTS_FOLDER    $PROVISION_FOLDER/vhosts
set_path_variables $argv[1]
set PHP_VERSION $argv[2]
set PHP_INI (echo "/etc/php/$PHP_VERSION/apache2/php.ini")

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	php$PHP_VERSION \
	php-pear \
	php$PHP_VERSION-bcmath \
	php$PHP_VERSION-bz2 \
	php$PHP_VERSION-cgi \
	php$PHP_VERSION-curl \
	php$PHP_VERSION-dom \
	php$PHP_VERSION-fpm \
	php$PHP_VERSION-gd \
	php$PHP_VERSION-imagick \
	php$PHP_VERSION-imap \
	php$PHP_VERSION-intl \
	php$PHP_VERSION-ldap \
	php$PHP_VERSION-mbstring \
	php$PHP_VERSION-mysql \
	php$PHP_VERSION-pgsql \
	php$PHP_VERSION-pspell \
	php$PHP_VERSION-soap \
	php$PHP_VERSION-xmlrpc \
	php$PHP_VERSION-zip \
	php$PHP_VERSION-apcu \
	php$PHP_VERSION-cli \
	php$PHP_VERSION-common \
	php$PHP_VERSION-enchant \
	php$PHP_VERSION-gmp \
	php$PHP_VERSION-gnupg \
	php$PHP_VERSION-memcache \
	php$PHP_VERSION-oauth \
	php$PHP_VERSION-opcache \
	php$PHP_VERSION-pcov \
	php$PHP_VERSION-psr \
	php$PHP_VERSION-readline \
	php$PHP_VERSION-redis \
	php$PHP_VERSION-sqlite3 \
	php$PHP_VERSION-tidy \
	php$PHP_VERSION-uuid \
	php$PHP_VERSION-xdebug \
	php$PHP_VERSION-xml \
	php$PHP_VERSION-xsl \
	php$PHP_VERSION-zstd \
	libapache2-mod-php$PHP_VERSION

set -x DEBIAN_FRONTEND noninteractive

# Start _script_title_ logic...

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
# Functions

# Function form
#function function_name
#    ... Function body ...
#    if not [SOME_CHECK]
#        handle_error "Failed to perform some action."
#    end
#    announce_success "Successfully completed some action." # optional
#end

# Example usage:
#function_name
#function_name argument
#function_name argument1 argument2

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
# Execution

# Add repository for ondrej/php
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/php

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

sed -i 's/max_execution_time = .*/max_execution_time = 60/' $PHP_INI
sed -i 's/post_max_size = .*/post_max_size = 64M/' $PHP_INI
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' $PHP_INI
sed -i 's/memory_limit = .*/memory_limit = 512M/' $PHP_INI
sed -i 's/display_errors = .*/display_errors = on/' $PHP_INI
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' $PHP_INI

cp /var/www/provision/html/phpinfo.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

a2enmod (echo "php$PHP_VERSION")

# Restart Apache to apply changes
systemctl restart apache2

announce_success "PHP Installed Successfully! ✅"

if not curl -sS https://getcomposer.org/installer | \
	sudo php -- --install-dir=/usr/local/bin --filename=composer
	handle_error "Failed to install Composer"
end

announce_success "Composer Installed Successfully! ✅"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 PHP Installed (with Composer) ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
