# 04 Install Apache

--

### Create `provision/scripts/install_apache.sh`

```
#!/bin/sh

# 04 Install Apache

# Variables...
# NONE!"

echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🚀 Installing Apache 🚀"
echo "Script Name:  install_apache.sh"
echo "Last Updated: 2023-01-19"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Add repository for ondrej/apache2
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

# Function to install packages with error handling
install_packages() {
	if ! apt-get -qy install "$@"; then
		echo "⚠️ Error: Failed to install packages 💥"
		exit 1
	fi
}

# Function to copy files into place & set permissions
copy_files() {
	yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
	yes | cp /var/www/provision/html/index.htm /var/www/html/
	yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

	sudo chmod -R 755 /var/www/html/*
}

# Function to enable site, disable site, and enable modules with error handling
enable_disable_modules_sites() {
	if ! a2ensite "$1" && ! a2dissite "$2" && ! a2enmod "$3" && ! a2enmod ssl; then
		echo "⚠️ Error: Failed to configure Apache sites and modules 💥"
		exit 1
	fi
}

# Call the function with the packages you want to install
install_packages \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

echo ""
echo "✅ Apache Installation: Packages installed successfully!"
echo ""

# Call the function to copy files
copy_files

# Call the function to enable/disable sites and enable modules (including ssl)
enable_disable_modules_sites local.conf 000-default rewrite

service apache2 restart

echo ""
echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🏆 Apache Installed ‼️"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
```

### Create `provision/html/index.htm`

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

### Create `provision/vhosts/local.conf`

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

Or (*only if the VM is running*)...

```
vagrant provision
```

### Visit

* [http://192.168.42.100/](http://192.168.42.100/)

... you should see the Apache default page of your VM.


### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [03 Install Utilities](./03_Install_Utilities.md)
| [**Back to Steps**](../README.md)
| [05 Install PHP](./05_Install_PHP.md)
|
