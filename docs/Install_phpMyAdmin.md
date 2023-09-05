# 05 Install phpMyAdmin

--

### `Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 05 Install phpMyAdmin

INSTALL_APACHE      = false
INSTALL_PHP         = false
INSTALL_MYSQL       = false
INSTALL_PHPMYADMIN  = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"
# Folders
HOST_FOLDER         = "./shared"
REMOTE_FOLDER       = "/var/www"
# Software Versions
PHP_VERSION         = "8.2"
MYSQL_VERSION       = "8.1"
PHPMYADMIN_VERSION  = "5.2.1"
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

	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	if INSTALL_APACHE = true
		config.vm.provision :shell, path: "provision/scripts/apache.sh"
	end
	if INSTALL_PHP = true
		config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	end
	if INSTALL_MYSQL = true
		config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	end
	if INSTALL_PHPMYADMIN = true
		config.vm.provision :shell, path: "provision/scripts/phpmyadmin.sh", :args => [PHPMYADMIN_VERSION, DB_PASSWORD, REMOTE_FOLDER]
	end

end
```

**Create** `provision/scripts/phpmyadmin.sh`:

```
#!/bin/bash

# 05 Install phpMyAdmin

#PHPMYADMIN_VERSION  = $1 = "5.2.1"
#DB_PASSWORD         = $2 = "Pa$$w0rdTw0"
#REMOTE_FOLDER       = $3 = "/var/www"

apt-get update
apt-get install -y unzip

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get install -y phpmyadmin

rm -rf /usr/share/phpmyadmin

cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/$1/phpMyAdmin-$1-all-languages.zip
unzip phpMyAdmin-$1-all-languages.zip
rm phpMyAdmin-$1-all-languages.zip
mv phpMyAdmin-$1-all-languages $3/html/phpmyadmin

chmod -R 755 $3/html/phpmyadmin

phpenmod mbstring

systemctl restart apache2
```


### Run:

```
vagrant provision
```

or

```
vagrant reload --provision
```

* Visit [http://192.168.42.100/phpmyadmin/](http://192.168.42.100/phpmyadmin/), log in with user/password.

### Accessing the Database from Outside the VM

To access your database with a GUI you'll need to use a SSH connection. How to set this up depends on the software you're using, but in general these are the things you'll need to configure:

Item | Value
---- | -----
`Host` | 127.0.0.1
`Username` | myuser (which we've defined in mysql.sh)
`Password` | password (which we've also defined in mysql.sh)
`SSH Host` | 127.0.0.1
`SSH User` | vagrant
`SSH Key` | Can be found in this location in your project directory: /.vagrant/machines/default/virtualbox/private_key
`SSH Port` | 2222

--

* [04 MySQL](./04_MySQL.md)
* [**Back to Steps**](../README.md)
* [06 Domain Names](./06_Domain_Names.md)
