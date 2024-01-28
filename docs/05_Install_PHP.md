# 06 Install PHP (with Composer 🙃)

**Updated:** 2024-01-28

--

### Create `provision/scripts/05_install_php.fish`

```
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
#set PHP_VERSION $1      # production
set PHP_VERSION "8.3"   # testing

set PACKAGE_LIST \
	php$PHP_VERSION \
	php$PHP_VERSION-common \
	php$PHP_VERSION-apcu \
	php$PHP_VERSION-bcmath \
	php$PHP_VERSION-bz2 \
	php$PHP_VERSION-cgi \
	php$PHP_VERSION-cli \
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
	php$PHP_VERSION-opcache \
	php$PHP_VERSION-pcov \
	php$PHP_VERSION-pgsql \
	php$PHP_VERSION-pspell \
	php$PHP_VERSION-readline \
	php$PHP_VERSION-redis \
	php$PHP_VERSION-soap \
	php$PHP_VERSION-xdebug \
	php$PHP_VERSION-xmlrpc \
	php$PHP_VERSION-zip \
	php-common \
	php-apcu \
	php-composer-ca-bundle \
	php-google-recaptcha \
	php-mysql \
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
	php-symfony-cache \
	php-symfony-cache-contracts \
	php-symfony-config \
	php-symfony-dependency-injection \
	php-symfony-expression-language \
	php-symfony-filesystem \
	php-symfony-finder \
	php-symfony-proxy-manager-bridge \
	php-symfony-service-contracts \
	php-symfony-var-exporter \
	php-symfony-yaml \
	php-tcpdf \
	php-twig \
	php-twig-doc \
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

# Update package lists
update_package_lists

# Install PHP packages
install_packages $PACKAGE_LIST

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$PHP_VERSION/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$PHP_VERSION/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$PHP_VERSION/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$PHP_VERSION/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$PHP_VERSION/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$PHP_VERSION/apache2/php.ini

cp /var/www/provision/html/phpinfo.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

a2enmod php$PHP_VERSION

service apache2 restart

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
```

### Create `provision/html/phpinfo.php`

```
<?php
phpinfo();
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 05 Install PHP
# Updated: 2024-01-20

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.3"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/02_upgrade_vm.sh"
#	config.vm.provision :shell, path: "provision/scripts/03_install_utilities.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/04_install_apache.fish"
	config.vm.provision :shell, path: "provision/scripts/05_install_php.fish", args: [PHP_VERSION]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_05 ./Vagrantfile
```

### Provision the VM

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
```

### Visit

* [http://192.168.42.100/phpinfo.php](http://192.168.42.100/phpinfo.php)

... which should successfully display the PHP info page.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [05 Install Apache](./05_Install_Apache.md)
| [**Back to Steps**](../README.md)
| [07 Install Composer](./07_Install_Composer.md)
|
