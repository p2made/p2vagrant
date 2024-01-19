# 07 Install MySQL

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

echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🚀 Installing MySQL 🚀"
echo "Script Name:  install_mysql.sh"
echo "Last Updated: 2023-01-19"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭
echo ""

export DEBIAN_FRONTEND=noninteractive

# Function to update package lists
echo "🔄 Updating package lists 🔄"
if ! apt-get -q update; then
	handle_error "⚠️ Failed to update package lists"
fi

apt-get -qy install mysql-server

# Create the database and grant privileges
echo "CREATE USER '$2'@'%' IDENTIFIED BY '$3'"      | mysql
echo "CREATE DATABASE IF NOT EXISTS $4"             | mysql
echo "CREATE DATABASE IF NOT EXISTS $5"             | mysql
echo "GRANT ALL PRIVILEGES ON $4.* TO '$2'@'%';"    | mysql
echo "GRANT ALL PRIVILEGES ON $5.* TO '$2'@'%';"    | mysql
echo "flush privileges"                             | mysql

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

cp /var/www/provision/html/db.php /var/www/html/

sudo chmod -R 755 /var/www/html/*

dpkg -l | grep "apache2\|mysql-server-8.1\|php8.2"

echo ""
echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🏆 MySQL Installed ‼️"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭
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
	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"
	config.vm.provision :shell, path: "provision/scripts/install_php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_composer.sh"
	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", :args => [MYSQL_VERSION, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_07 ./Vagrantfile
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

| [06 Install Composer](./06_Install_Composer.md)
| [**Back to Steps**](../README.md)
| [08 Install phpMyAdmin](./08_Install_phpMyAdmin.md)
|
