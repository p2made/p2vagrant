# 07 Install MySQL

Updated: 2024-02-03

--

### Create `provision/scripts/install_mysql.fish`

```
#!/bin/fish

# 06 Install MySQL

set script_name     "install_mysql.fish"
set updated_date    "2024-02-02"

set active_title    "Installing MySQL"
set job_complete    "MySQL Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - MYSQL_VERSION   = "8.1"
# 2 - PHP_VERSION     = "8.3"
# 3 - ROOT_PASSWORD   = ⚠️ See Vagrantfile
# 4 - DB_USERNAME     = ⚠️ See Vagrantfile
# 5 - DB_PASSWORD     = ⚠️ See Vagrantfile
# 6 - DB_NAME         = "example_db"
# 7 - DB_NAME_TEST    = "example_db_test"

# Script variables...

set MYSQL_VERSION  $argv[1]
set PHP_VERSION    $argv[2]
set ROOT_PASSWORD  $argv[3]
set DB_USERNAME    $argv[4]
set DB_PASSWORD    $argv[5]
set DB_NAME        $argv[6]
set DB_NAME_TEST   $argv[7]

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	mysql-server

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

sudo mkdir -p /var/www/provision/logs
sudo touch /var/www/provision/logs/mysql_output.log
sudo chmod -R 755 /var/www/provision/logs

# Set root password
mysqladmin -u root password $ROOT_PASSWORD || handle_error "Failed to set root password."

# Create the database and grant privileges
set -a sql_string (echo "CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_PASSWORD'")
set -a err_string (echo "Failed to create MySQL user")
set -a sql_string (echo "CREATE DATABASE IF NOT EXISTS $DB_NAME")
set -a err_string (echo "Failed to create MySQL database $DB_NAME")
set -a sql_string (echo "CREATE DATABASE IF NOT EXISTS $DB_NAME_TEST")
set -a err_string (echo "Failed to create MySQL database $DB_NAME_TEST")
set -a sql_string (echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USERNAME'@'%';")
set -a err_string (echo "Failed to grant privileges on $DB_NAME")
set -a sql_string (echo "GRANT ALL PRIVILEGES ON $DB_NAME_TEST.* TO '$DB_USERNAME'@'%';")
set -a err_string (echo "Failed to grant privileges on $DB_NAME_TEST")
set -a sql_string (echo "flush privileges")
set -a err_string (echo "Failed to flush privileges")

for i in (seq 1 6)
	echo $sql_string[$i] | mysql -u root -p$ROOT_PASSWORD > /var/www/provision/logs/mysql_output.log 2>&1 || \
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

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
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
# vi: set ft=ruby :

# 06 Install MySQL
# Updated: 2024-02-07

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
VM_IP               = "192.168.22.42"      # 22 = titanium, 42 = Douglas Adams's number

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.3"
MYSQL_VERSION       = "8.0"

# Database Variables
ROOT_PASSWORD       = "RootPassw0rd"
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
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_apache.fish"
#	config.vm.provision :shell, path: "provision/scripts/install_php.fish", args: [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_mysql.fish", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

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

* [http://192.168.22.42/db.php](http://192.168.22.42/db.php)

... if all went well you should be seeing the "*Connected!*" message.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 07 Install MySQL -->
| [06 Install PHP (with Composer)](./06_Install_PHP.md)
| [**Back to Steps**](../README.md)
| [08 Install phpMyAdmin](./08_Install_phpMyAdmin.md)
|
