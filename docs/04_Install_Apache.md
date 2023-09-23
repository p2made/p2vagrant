# 04 Install Apache

--

### Create `provision/scripts/install_apache.sh`:

```
#!/bin/sh

# 04 Install Apache

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Installing Apache                               #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

apt-get -qy install apache2
apt-get -qy install apache2-bin
apt-get -qy install apache2-data
apt-get -qy install apache2-utils

yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/html/index.htm /var/www/html/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

sudo chmod -R 755 /var/www/html/*

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

service apache2 restart
```

### Create `provision/vhosts/local.conf`:

```
<VirtualHost *:80>
	ServerAdmin admin@example.com
	DocumentRoot /var/www/html
	DirectoryIndex index.html index.php

	<Directory /var/www/html>
		# Allow .htaccess rewrite rules
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	ErrorLog "/var/log/apache2/localhost-error_log"
	CustomLog "/var/log/apache2/localhost-access_log" common
</VirtualHost>
```

### Create `provision/html/index.htm`:

```
<html>
<head>
	<title>Awesome Test Project</title>
</head>
<body>
	<h1>Shaka Bom!</h1>
	<p>How cool is this?</p>
</body>
</html>
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 04 Install Apache

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane"
#TIMEZONE            = "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

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

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_04 ./Vagrantfile
```

### Provision the VM

```
vagrant reload --provision
```

Or (if the VM is running)...

```
vagrant provision
```

### Visit:

* [http://192.168.42.100/](http://192.168.42.100/)

... you should see the Apache default page of your VM.

**Optionally** edit `HOST_FOLDER/html/index.html`:

```
<html>
<head>
	<title>Awesome Test Project</title>
</head>
<body>
	<h1>Shaka Bom!</h1>
	<p>How cool is this?</p>
</body>
</html>
```

The page is a simple `index.html` located within your VM in the `/var/www/html` directory, the so-called document root. This document root is the directory that's available from the outside to your server.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 04 Install Apache -->
| [03 Install Utilities](./03_Install_Utilities.md)
| [**Back to Steps**](../README.md)
| [05 Install PHP](./05_Install_PHP.md)
|
