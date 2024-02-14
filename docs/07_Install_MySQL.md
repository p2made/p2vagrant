# 07 Install MySQL

Updated: 2024-02-13

--

### Create `provision/scripts/install_mysql.fish`

```
#!/bin/fish

# 08 Install MySQL

set script_name     "install_mysql.fish"
set updated_date    "2024-02-12"

set active_title    "Installing MySQL"
set job_complete    "MySQL Installed"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
set MYSQL_VERSION   $argv[1] # "8.0"
set PHP_VERSION     $argv[2] # "8.3"
set ROOT_PASSWORD   $argv[3] # ⚠️ See Vagrantfile
set DB_USERNAME     $argv[4] # ⚠️ See Vagrantfile
set DB_PASSWORD     $argv[5] # ⚠️ See Vagrantfile
set DB_NAME         $argv[6] # "example_db"
set DB_NAME_TEST    $argv[7] # "example_db_test"

# Script variables...
set -a sql_string (echo "CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD'")
set -a sql_string (echo "CREATE DATABASE IF NOT EXISTS $DB_NAME")
set -a sql_string (echo "CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST")
set -a sql_string (echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';")
set -a sql_string (echo "GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%';")
set -a sql_string (echo "flush privileges")

set -a err_string (echo "Failed to create MySQL user")
set -a err_string (echo "Failed to create MySQL database $DB_NAME")
set -a err_string (echo "Failed to create MySQL database $DB_NAME_TEST")
set -a err_string (echo "Failed to grant privileges on $DB_NAME")
set -a err_string (echo "Failed to grant privileges on $DB_NAME_TEST")
set -a err_string (echo "Failed to flush privileges")

# Always set package_list when using install_packages or update_and_install_packages
set package_list \
	mysql-server

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to install MySQL
# Usage: install_mysql
function install_mysql
	# Update package lists & install packages
	update_and_install_packages $package_list

	# Set root password
	mysqladmin -u root password $ROOT_PASSWORD || handle_error "Failed to set root password."

	# Create the database and grant privileges
	for i in (seq 1 6)
		echo $sql_string[$i] | mysql -u root -p$ROOT_PASSWORD || \
			handle_error $err_string[$i]
	end

	# Update MySQL configuration
	if test -f /etc/mysql/mysql.conf.d/mysqld.cnf
		sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
	else
		handle_error "mysqld.cnf file not found."
	end

	# Copy database file
	cp $PROVISION_HTML/db.php $SHARED_HTML/ || \
		handle_error "Failed to copy db.php file"

	# Set permissions
	sudo chmod -R 755 $SHARED_HTML/ || \
		handle_error "Failed to set permissions on $SHARED_HTML/"
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function provision
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	set -x DEBIAN_FRONTEND noninteractive

	install_mysql

	# Footer banner
	footer_banner "$job_complete"
end

provision
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

Replace `db_user `, `db_password `, & `db `, with values from your `Vagrantfile`.

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 08 Install MySQL
# Generated: 2024-02-13

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
VM_FOLDER       = "/var/www"

# Software Versions
SWIFT_VERSION       = "5.9.2"
PHP_VERSION         = "8.3"
MYSQL_VERSION       = "8.3"

# Database Variables
ROOT_PASSWORD       = "RootPassw0rd"
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rd"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory    = MEMORY
		v.cpus      = CPUS
		v.gui       = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, VM_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", args: [VM_HOSTNAME], run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh"
#	config.vm.provision :shell, path: "provision/scripts/install_swift.fish", args: [SWIFT_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_apache.fish", args: [VM_HOSTNAME, VM_IP]
#	config.vm.provision :shell, path: "provision/scripts/install_php.fish", args: [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_mysql.fish", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

end
```

Or run...

```
./vg 8
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

* [https://p2vagrant/db.php](https://p2vagrant/db.php)

... if all went well you should be seeing the "*Connected!*" message.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 07 Install MySQL -->
| [06 Install PHP (with Composer)](./06_Install_PHP.md)
| [**Back to Steps**](../README.md)
| [08 Install phpMyAdmin](./08_Install_phpMyAdmin.md)
|

--

p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳

--
