# 03 Installing PHP 8.2

--

### `Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
HOST_FOLDER         = "./public"
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.2"

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

end
```

**Create** `provision/scripts/php.sh`:

```
#!/bin/bash

apt-get install software-properties-common
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

apt-get update
apt-get install -y php$1 php$1-mysql

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$1/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$1/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$1/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$1/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$1/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$1/apache2/php.ini

service apache2 restart
```

**Create** `HOST_FOLDER/html/phpinfo.php`:

```
<?php
phpinfo();
```

### Run:

```
vagrant provision
```

* When finished, [http://192.168.98.99/phpinfo.php](http://192.168.98.99/phpinfo.php), which should successfully display the PHP info page.

--

* [02 Apache](./02_Apache.md)
* [**Back to Steps**](../README.md)
* [04 MySQL](./04_MySQL.md)
