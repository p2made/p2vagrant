# 03 Install PHP 8.2

--

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 03 Install PHP 8.2

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"

# Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.2"

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
	config.vm.provision :shell, path: "provision/scripts/upgrade.sh"
	config.vm.provision :shell, path: "provision/scripts/utilities.sh"
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]

end
```

Copy this file...

```
cp ./Vagrantfiles/Vagrantfile_03 ./Vagrantfile
```

### Create `provision/scripts/php.sh`:

```
#!/bin/bash

# 03 Install PHP 8.2

#PHP_VERSION         = $1 = 8.2

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php

apt-get update

apt-get install -y php$1 php-common
apt-get install -y php$1-{bcmath,bz2,cgi,cli,common,curl,dom,exif,fileinfo,filter,fpm,gd,hash,iconv,imagick,imap,intl,json,ldap,mbstring,mcrypt,mysql,mysqli,opcache,openssl,pcre,pgsql,pspell,readline,simplexml,soap,sodium,xml,xmlreader,xmlrpc,zip,zlib}
apt-get install -y php-pear libapache2-mod-php$1

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$1/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$1/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$1/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$1/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$1/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$1/apache2/php.ini

a2enmod php$1

#service apache2 restart
systemctl restart apache2

php -v
php -m
```

### Run:

```
vagrant provision
```

or

```
vagrant reload --provision
```

### Create `HOST_FOLDER/html/phpinfo.php`:

```
<?php
phpinfo();
```

Copy this file...

```
cp ./provision/html/phpinfo.html ./shared/html/phpinfo.html
```

### Visit:

* [http://192.168.42.100/phpinfo.php](http://192.168.42.100/phpinfo.php)

... which should successfully display the PHP info page.

### All good?

Save the moment with a snapshot...

```
vagrant halt
vagrant snapshot push
vagrant up
```

--

<!-- 03 Install PHP 8.2 -->
| [02 Install Apache](./02_Install_Apache.md)
| [**Back to Steps**](../README.md)
| [04 Install MySQL](./04_Install_MySQL.md)
|
