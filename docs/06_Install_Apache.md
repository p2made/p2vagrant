# 06 Install Apache (with SSL 🙃)

Updated: 2024-02-12

--

### Create `provision/scripts/install_apache.fish`

```
#!/bin/fish

# 05 Install Apache (with SSL)

set script_name     "install_apache.fish"
set updated_date    "2024-02-12"

set active_title    "Installing Apache (with SSL 🙃)"
set job_complete    "Apache Installed (with SSL 🙃)"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - VM_IP = "192.168.22.42"

# Script variables...
# NONE!"

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to install Apache
# Usage: install_apache
function install_apache
	# Add repository for ondrej/apache2
	LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

	# Update package lists & install packages
	update_and_install_packages $PACKAGE_LIST

	announce_success "Apache packages installed successfully!"

	set domain            $VM_IP
	set ssl_base_filename "$VM_IP"_"$TODAYS_DATE"

	generate_ssl_files $domain $ssl_base_filename

	# Copy web server files into place
	yes | cp $PROVISION_VHOSTS/local.conf /etc/apache2/sites-available/
	yes | cp $PROVISION_SSL/* /etc/apache2/sites-available/
	yes | cp $PROVISION_HTML/index.htm $SHARED_HTML/

	# Check if index.html exists in the html folder
	if not test -e $SHARED_HTML/index.html
		cp $PROVISION_HTML/index.html $SHARED_HTML/
	end

	# Set permissions on web server files
	chmod -R 755 $SHARED_HTML/*
	chmod 600 /etc/apache2/sites-available/$ssl_base_filename.key

	a2ensite local.conf
	a2dissite 000-default
	a2enmod rewrite
	a2enmod ssl

	# Restart Apache to apply changes
	systemctl restart apache2
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function advance_vm
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	set -x DEBIAN_FRONTEND noninteractive

	install_apache

	# Footer banner
	footer_banner "$job_complete"
end

advance_vm
```

### Create `provision/html/index.htm`

```
<html>
<head>
	<title>Shaka Bom!</title>
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
    DirectoryIndex index.htm index.html index.php

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
# vi: set ft=ruby

# 06 Install Apache (with SSL)
# Generated: 2024-02-12

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
SWIFT_VERSION       = "5.9.2"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory    = MEMORY
		v.cpus      = CPUS
		v.gui       = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", args: [VM_HOSTNAME], run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh"
#	config.vm.provision :shell, path: "provision/scripts/install_swift.fish", args: [SWIFT_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_apache.fish"

end
```

Or run...

```
./vg 6
```

### Provision the VM...

If the VM is **not** running

```
vagrant up --provision
```

If the VM is running

```
vagrant reload --provision
```

### Visit

* [http://192.168.22.42/](http://192.168.22.42/)
* [http://192.168.22.42/](http://192.168.22.42/)

You should see a minimal page that I put there. For the Apache default page of your VM visit...

* [http://192.168.22.42/index.html](http://192.168.22.42/index.html)
* [http://192.168.22.42/index.html](http://192.168.22.42/index.html)


### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 05 Install Apache (with SSL) -->
| [04 Upgrade VM (revisited)](./04_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [06 Install PHP (with Composer)](./06_Install_PHP.md)
|
