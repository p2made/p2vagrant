# 08 Install MySQL

**Updated:** 2024-01-28

--

### Create `provision/scripts/06_install_mysql.fish`

```
#!/bin/fish

# 06 Install MySQL

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing MySQL 🚀"
echo "🇺🇿    📜 Script Name:  06_install_mysql.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-28"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Variables...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - DB_USERNAME     = "fredspotty"
# 3 - DB_PASSWORD     = "Passw0rd"
# 4 - DB_NAME         = "example_db"
# 5 - DB_NAME_TEST    = "example_db_test"
# 6 - PHP_VERSION     = "8.3"

set MYSQL_VERSION $1                # prod
#set MYSQL_VERSION "8.1"             # test
set DB_USERNAME $2                  # prod
#set DB_USERNAME "fredspotty"        # test
set DB_PASSWORD $3                  # prod
#set DB_PASSWORD "Passw0rd"          # test
set DB_NAME $4                      # prod
#set DB_NAME "example_db"            # test
set DB_NAME_TEST $5                 # prod
#set DB_NAME_TEST "example_db_test"  # test
set PHP_VERSION $46                 # prod
#set PHP_VERSION "8.3"               # test

set PACKAGE_LIST \
	mysql-server

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

# Update package lists
update_package_lists

# Install PHP packages
install_packages $PACKAGE_LIST

# Create the database and grant privileges
echo "CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD'" | \
	mysql || handle_error "Failed to create MySQL user"

echo "CREATE DATABASE IF NOT EXISTS $DB_NAME" | \
	mysql || handle_error "Failed to create MySQL database $DB_NAME"

echo "CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST" | \
	mysql || handle_error "Failed to create MySQL database $DB_NAME_TEST"

echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';" | \
	mysql || handle_error "Failed to grant privileges on $DB_NAME"

echo "GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%';" | \
	mysql || handle_error "Failed to grant privileges on $DB_NAME_TEST"

echo "flush privileges" | \
	mysql || handle_error "Failed to flush privileges"

# Update MySQL configuration
if test -f /etc/mysql/mysql.conf.d/mysqld.cnf
	sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
else
	handle_error "mysqld.cnf file not found."
end

# Copy database file
cp /var/www/provision/html/db.php /var/www/html/ || \
	handle_error "Failed to copy db.php file"

# Set permissions
sudo chmod -R 755 /var/www/html/ || \
	handle_error "Failed to set permissions on /var/www/html/"

apt-get list --installed | \
	grep -E "apache2|mysql-server-$MYSQL_VERSION|php$PHP_VERSION" | \
	awk '{print $1, $2}'

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 MySQL Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
```

### Create `provision/html/db.php`

```
<?php
$host       = "localhost";
$username   = "fredspotty";
$password   = "Passw0rd";
$database   = "example_db";

$conn = mysqli_connect($host, $username, $password, $database);

if (!$conn) {
    die("Error: " . mysqli_connect_error());
}

echo "Connected!";
```

Replace `db_user `, `db_password `, & `db `, with values from `Vagrantfile`.

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 06 Install MySQL
# Updated: 2024-01-28

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
MYSQL_VERSION       = "8.1"

# Database Variables
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rd"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"

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
#	config.vm.provision :shell, path: "provision/scripts/05_install_php.fish", args: [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/06_install_mysql.fish", args: [MYSQL_VERSION, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_06 ./Vagrantfile
```

**Customise**

* `RT_PASSWORD`
* `DB_USERNAME`
* `DB_PASSWORD`
* `DB_NAME`
* `DB_NAME_TEST`

### Provision the VM

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
```

`db.php` will be copied to `HOST_FOLDER/html/`.

### Visit:

* [https://192.168.42.100/db.php](https://192.168.42.100/db.php)

... if all went well you should be seeing the "*Connected!*" message.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [07 Install Composer](./07_Install_Composer.md)
| [**Back to Steps**](../README.md)
| [09 Install phpMyAdmin](./09_Install_phpMyAdmin.md)
|
