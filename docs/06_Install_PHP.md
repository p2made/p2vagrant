# 07 Install PHP (with Composer 🙃)

Updated: 2024-02-13

--

### Create `provision/scripts/install_php.fish`

```
#!/bin/fish

# 06 Install PHP (with Composer)

set script_name     "install_php.fish"
set updated_date    "2024-02-12"

set active_title    "Installing PHP (with Composer 🙃)"
set job_complete    "PHP Installed (with Composer 🙃)"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

header_banner $active_title $script_name $updated_date
# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
set PHP_VERSION    $argv[1]

# Script variables...
set PHP_INI        /etc/php/$PHP_VERSION/apache2/php.ini

# Always set package_list when using update_and_install_packages
set package_list \
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

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to install PHP
# Usage: install_php
function install_php
	# Add repository for ondrej/php
	LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/php

	# Update package lists & install packages
	update_and_install_packages $package_list

	sed -i 's/max_execution_time = .*/max_execution_time = 60/'         $PHP_INI
	sed -i 's/post_max_size = .*/post_max_size = 64M/'                  $PHP_INI
	sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/'       $PHP_INI
	sed -i 's/memory_limit = .*/memory_limit = 512M/'                   $PHP_INI
	sed -i 's/display_errors = .*/display_errors = on/'                 $PHP_INI
	sed -i 's/display_startup_errors = .*/display_startup_errors = on/' $PHP_INI

	cp $PROVISION_HTML/phpinfo.php $SHARED_HTML/
	sudo chmod -R 755 $SHARED_HTML/*

	a2enmod php$PHP_VERSION proxy_fcgi setenvif
	a2enconf php$PHP_VERSION-fpm

	# Restart Apache to apply changes
	systemctl restart apache2

	announce_success "PHP Installed Successfully! ✅"
end

# Function to install Composer
# Usage: install_composer
function install_composer
	if not curl -sS https://getcomposer.org/installer | \
		sudo php -- --install-dir=/usr/local/bin --filename=composer
		handle_error "Failed to install Composer"
	end

	announce_success "Composer Installed Successfully! ✅"
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function provision
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	set -x DEBIAN_FRONTEND noninteractive

	install_php
	install_composer

	# Footer banner
	footer_banner "$job_complete"
end

provision
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

# 06 Install PHP (with Composer)
# Updated: 2024-02-07

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
VM_IP               = "192.168.22.42"      # 22 = titanium, 42 = Douglas Adams's number

# Synced Folders
HOST_FOLDER         = "."
VM_FOLDER       = "/var/www"

# Software Versions
SWIFT_VERSION       = ""                   # "5.9.2" - if Swift is required
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
	config.vm.synced_folder HOST_FOLDER, VM_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [SWIFT_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_apache.fish", args: [VM_IP]
	config.vm.provision :shell, path: "provision/scripts/install_php.fish", args: [PHP_VERSION]

end
```

Or run...

```
./vg 7
```

### Provision the VM

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
```

`phpinfo.php` will be copied to `HOST_FOLDER/html/`.

### Visit

* [https://p2vagrant/phpinfo.php](https://p2vagrant/phpinfo.php)

... which should successfully display the PHP info page.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 06 Install PHP (with Composer) -->
| [05 Install Apache (with SSL & Markdown)](./05_Install_Apache.md)
| [**Back to Steps**](../README.md)
| [07 Install MySQL](./07_Install_MySQL.md)
|

--

p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳

--
