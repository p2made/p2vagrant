# 08 Install MySQL

--

### Create `provision/scripts/install_mysql.sh`

```
#!/bin/sh

# 07 Install MySQL

# Variables...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - DB_USERNAME     = "fredspotty"
# 3 - DB_PASSWORD     = "Passw0rd"
# 4 - DB_NAME         = "example_db"
# 5 - DB_NAME_TEST    = "example_db_test"

# Function for error handling
handle_error() {
	echo "⚠️ Error: $1 💥"
	exit 1
}

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🚀 Installing MySQL 🚀"
echo "📜 Script Name:  install_mysql.sh"
echo "📅 Last Updated: 2024-01-20"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Call the vm_upgrade.sh script
/var/www/provision/scripts/vm_upgrade.sh || handle_error "Failed to upgrade VM"

# Install MySQL
if ! apt-get -qy install mysql-server; then
	handle_error "Failed to install MySQL"
fi

# Create the database and grant privileges
echo "CREATE USER '$2'@'%' IDENTIFIED BY '$3'"      | mysql || handle_error "Failed to create MySQL user"
echo "CREATE DATABASE IF NOT EXISTS $4"             | mysql || handle_error "Failed to create MySQL database $4"
echo "CREATE DATABASE IF NOT EXISTS $5"             | mysql || handle_error "Failed to create MySQL database $5"
echo "GRANT ALL PRIVILEGES ON $4.* TO '$2'@'%';"    | mysql || handle_error "Failed to grant privileges on $4"
echo "GRANT ALL PRIVILEGES ON $5.* TO '$2'@'%';"    | mysql || handle_error "Failed to grant privileges on $5"
echo "flush privileges"                             | mysql || handle_error "Failed to flush privileges"

# Update MySQL configuration
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Copy database file
cp /var/www/provision/html/db.php /var/www/html/ || handle_error "Failed to copy db.php file"

# Set permissions
sudo chmod -R 755 /var/www/html/ || handle_error "Failed to set permissions on /var/www/html/"

# Display installed packages
dpkg -l | grep "apache2\|mysql-server-$1\|php8.2"

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 MySQL Installed ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
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
# vi: set ft=ruby

# 07 Install MySQL
# Updated: 2024-01-20

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

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: 'always'

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
	config.vm.provision :shell, path: "provision/scripts/generate_ssl.sh", args: [SSL_DIR, CERT_NAME]
	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"
	config.vm.provision :shell, path: "provision/scripts/install_php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_composer.sh"
	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", :args => [MYSQL_VERSION, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_08 ./Vagrantfile
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

* [http://192.168.42.100/db.php](http://192.168.42.100/db.php)

... if all went well you should be seeing the "*Connected!*" message.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [07 Install Composer](./07_Install_Composer.md)
| [**Back to Steps**](../README.md)
| [09 Install phpMyAdmin](./09_Install_phpMyAdmin.md)
|
