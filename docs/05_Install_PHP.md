# 05 Install PHP

--

### Create `provision/scripts/install_php.sh`

```
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
	php$1-mysql \
	php$1-pgsql \
	php$1-pspell \
	php$1-soap \
	php$1-xmlrpc \
	php$1-zip \
	php-pear \
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
echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🏆 PHP Installed ‼️"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
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

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane"
#TIMEZONE            = "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.2"

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

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: 'always'

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"
	config.vm.provision :shell, path: "provision/scripts/install_php.sh", :args => [PHP_VERSION]

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

| [04 Install Apache](./04_Install_Apache.md)
| [**Back to Steps**](../README.md)
| [06 Install Composer](./06_Install_Composer.md)
|
