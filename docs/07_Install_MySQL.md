# 07 Install MySQL

--

### Create `provision/scripts/install_mysql.fish`

```
#!/bin/bash

# 07 Install MySQL

script_name="install_mysql.sh"
updated_date="2024-02-15"

active_title="Installing MySQL"
job_complete="MySQL Installed"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

# Arguments...
MYSQL_VERSION=$1    # "8.0"
PHP_VERSION=$2      # "8.3"
ROOT_PASSWORD=$3    # ⚠️ See Vagrantfile
DB_USERNAME=$4      # ⚠️ See Vagrantfile
DB_PASSWORD=$5      # ⚠️ See Vagrantfile
DB_NAME=$6          # "example_db"
DB_NAME_TEST=$7     # "example_db_test"

# Script variables...
sql_string=(
	"CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD';"
	"CREATE DATABASE IF NOT EXISTS $DB_NAME;"
	"CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST;"
	"GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';"
	"GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%';"
	"FLUSH PRIVILEGES;"
)

err_string=(
	"Failed to create MySQL user"
	"Failed to create MySQL database $DB_NAME"
	"Failed to create MySQL database $DB_NAME_TEST"
	"Failed to grant privileges on $DB_NAME"
	"Failed to grant privileges on $DB_NAME_TEST"
	"Failed to flush privileges"
)

# Always set package_list when using update_and_install_packages
package_list=(
	"mysql-server"
)

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to install MySQL
# Usage: install_mysql
function install_mysql() {
	# Update package lists & install packages
	update_package_lists
	install_packages "$package_list"

	# Set root password
	mysqladmin -u root password "$ROOT_PASSWORD" ||
		handle_error "Failed to set root password."

	# Create the database and grant privileges
	for ((i = 0; i < ${#sql_string[@]}; i++)); do
		echo "${sql_string[i]}" | mysql -u root -p"$ROOT_PASSWORD" ||
			handle_error "${err_string[i]}"
	done

	# Update MySQL configuration
	if [[ -f /etc/mysql/mysql.conf.d/mysqld.cnf ]]; then
		sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
	else
		handle_error "mysqld.cnf file not found."
	fi

	# Copy database file
	cp "$PROVISION_HTML/db.php" "$SHARED_HTML/"

	# Set permissions
	sudo chmod -R 755 "$SHARED_HTML/" ||
		handle_error "Failed to set permissions on $SHARED_HTML/"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function provision() {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	install_mysql

	# Footer banner
	footer_banner "$job_complete"
}

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

# 07 Install MySQL
# Generated: 2024-02-15

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
VM_FOLDER           = "/var/www"

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
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [VM_HOSTNAME, TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_swift.sh", args: [SWIFT_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_apache.sh", args: [VM_HOSTNAME]
#	config.vm.provision :shell, path: "provision/scripts/install_php.sh", args: [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

end
```

Or run...

```
./vg 7
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
