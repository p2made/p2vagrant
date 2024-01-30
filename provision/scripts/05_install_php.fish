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

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Arguments...
# 1 - PHP_VERSION     = "8.3"

# Script variables...
set PHP_VERSION $argv[1]

set -a PACKAGE_LIST (echo "php$PHP_VERSION php-pear")
set -a PACKAGE_LIST (echo "php$PHP_VERSION-{bcmath,bz2,cgi,curl,dom,fpm,gd,imagick,imap,intl}")
set -a PACKAGE_LIST (echo "php$PHP_VERSION-{ldap,mbstring,mcrypt,mysql,pgsql,pspell,soap,xmlrpc,zip}")
set -a PACKAGE_LIST (echo "php$PHP_VERSION-{apcu,cli,common,enchant,gmp,gnupg,memcache,oauth,opcache,pcov,psr}")
set -a PACKAGE_LIST (echo "php$PHP_VERSION-{readline,redis,sqlite3,tidy,uuid,xdebug,xml,xsl,zstd}")
set -a PACKAGE_LIST (echo "libapache2-mod-php$PHP_VERSION")

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
