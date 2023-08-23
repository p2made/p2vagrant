# 05 phpMyAdmin

--

### `Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
TLD                 = "tld"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.2"
PHPMYADMIN_VERSION  = "5.2.1"
MYSQL_VERSION       = "8.1"
COMPOSER_VERSION    = "2.1.6"
RT_PASSWORD         = "password"
DB_USERNAME         = "user"
DB_PASSWORD         = "password"
DB_NAME             = "db"
DB_NAME_TEST        = "db_test"

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
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/phpmyadmin.sh", :args => [PHPMYADMIN_VERSION, DB_PASSWORD, REMOTE_FOLDER]
	config.vm.provision :shell, path: "provision/scripts/composer.sh", :args => [COMPOSER_VERSION]
	config.vm.provision :shell, path: "provision/scripts/yarn.sh"
	config.vm.provision :shell, path: "provision/scripts/profile.sh"

	config.vm.provision :shell, path: "provision/scripts/sites.sh"

end
```

**Create** `provision/scripts/somefile.sh`:

```
somefile
```

### Run:

```
vagrant reload --provision
```

--

* [04 MySQL](./04_MySQL.md)
* [**Back to Steps**](../README.md)
* [06 Domain Names](./06_Domain_Names.md)

