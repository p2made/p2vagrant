# 05 Install MySQL 8.1

--

### `Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 05 Install MySQL 8.1

INSTALL_APACHE      = false
INSTALL_PHP         = false
INSTALL_MYSQL       = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
SSH_PASSWORD        = 'vagrant'
# Folders
HOST_FOLDER         = "./shared"
REMOTE_FOLDER       = "/var/www"
# Software Versions
PHP_VERSION         = "8.2"
MYSQL_VERSION       = "8.1"
# Database Variables
RT_PASSWORD         = "Pa$$w0rd0ne"
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Pa$$w0rdTw0"
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

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	if INSTALL_APACHE
		config.vm.provision :shell, path: "provision/scripts/apache.sh"
	end
	if INSTALL_PHP
		config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	end
	if INSTALL_MYSQL
		config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	end

end
```

**Customise**

* `RT_PASSWORD`
* `DB_USERNAME`
* `DB_PASSWORD`
* `DB_NAME`
* `DB_NAME_TEST`

**Create** `provision/scripts/mysql.sh`:

```
#!/bin/bash

# 05 Install MySQL 8.1

#MYSQL_VERSION   = $1
#RT_PASSWORD     = $2
#DB_USERNAME     = $3
#DB_PASSWORD     = $4
#DB_NAME         = $5
#DB_NAME_TEST    = $6

# Install MySQL
apt-get update
apt-get -y install mysql-server

debconf-set-selections <<< "mysql-server mysql-server/root_password password Pa$$w0rd0ne"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password Pa$$w0rd0ne"

# Create the database and grant privileges
CMD="sudo mysql -uroot -p$2 -e"

$CMD "CREATE USER '$3'@'%' IDENTIFIED BY '$4';"
$CMD "CREATE DATABASE IF NOT EXISTS $5"
$CMD "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%'"
$CMD "CREATE DATABASE IF NOT EXISTS $6"
$CMD "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%'"

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
#grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart
```

### Run:

```
vagrant provision
```

or

```
vagrant reload --provision
```

**Create** `HOST_FOLDER/html/db.php`:

```
<?php
$conn = mysqli_connect("localhost", "db_user", "db_password", "db");

if (!$conn) {
	die("Error: " . mysqli_connect_error());
}

echo "Connected!";
```

Peplace `localhost`, `db_user`, `db_password`, `db` with the values used in `Vagrantfile`.

* Visit [http://192.168.98.99/db.php](http://192.168.98.99/db.php) and if all went well you should be seeing the "*Connected!*" message.

All good? Save the moment with a snapshot...

```
vagrant halt
vagrant snapshot push
vagrant up
```

--

<!-- Install MySQL 8.1 -->
| [04 Install PHP](./04_Install_PHP.md)
| [**Back to Steps**](../README.md)
| [06 Install phpMyAdmin](./06_Install_phpMyAdmin.md)
|
