
# 5. Install MySQL

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Test Project"
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"
PHPMYADMIN_VERSION  = "5.1.1"
MYSQL_VERSION       = "5.7"
COMPOSER_VERSION    = "2.1.6"
RT_PASSWORD         = "password"
DB_USERNAME         = "user"
DB_PASSWORD         = "password"
DB_NAME             = "db"
DB_NAME_TEST        = "db_test"

# Hosts - never empty these variables, but replace them if you need additional hostnames
HOST_0              = "example.localhost"
HOST_1              = "example1.localhost"
HOST_2              = "example2.localhost"
HOST_3              = "example3.localhost"
HOST_4              = "example4.localhost"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/ssl.sh", :args => [HOST_0, HOST_1, HOST_2, HOST_3, HOST_4]
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

end
```

Customise `RT_PASSWORD`, `DB_USERNAME`, `DB_PASSWORD`, `DB_NAME`, & `DB_NAME_TEST` to suit yourself.

Create `provision/scripts/mysql.sh`:

```
#!/bin/bash

# MYSQL_VERSION    $1
# RT_PASSWORD      $2
# DB_USERNAME      $3
# DB_PASSWORD      $4
# DB_NAME          $5
# DB_NAME_TEST     $6

# Install MySQL
apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $2"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $2"

apt-get -y install mysql-server-$1

# Create the database and grant privileges
CMD="sudo mysql -uroot -p$2 -e"

$CMD "CREATE DATABASE IF NOT EXISTS $5"
$CMD "GRANT ALL PRIVILEGES ON $5.* TO '$3'@'%' IDENTIFIED BY '$4';"
$CMD "CREATE DATABASE IF NOT EXISTS $6"
$CMD "GRANT ALL PRIVILEGES ON $6.* TO '$3'@'%' IDENTIFIED BY '$4';"
$CMD "FLUSH PRIVILEGES;"

sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
grep -q "^sql_mode" /etc/mysql/mysql.conf.d/mysqld.cnf || echo "sql_mode = STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION" >> /etc/mysql/mysql.conf.d/mysqld.cnf

service mysql restart
```

Run:

```
vagrant provision
```

Create `HOST_FOLDER/html/db.php`:

```
<?php
$conn = mysqli_connect("localhost", "user", "password", "db");

if (!$conn) {
	die("Error: " . mysqli_connect_error());
}

echo "Connected!";
```

Peplace `localhost`, `user`, `password`, `db` with the values used in `Vagrantfile`.

* Visit [http://192.168.88.188/db.php](http://192.168.88.188/db.php) and if all went well you should be seeing the "*Connected!*" message.

--
* [Install phpMyAdmin](./06_Install_phpMyAdmin.md)
* [Back to Steps](./00_Steps.md)
