# 02 Install Apache

--

## 01 Update `Vagrantfile`

Here I've started to group variables for easier following.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 02 Install Apache

UPGRADE_BOX         = true
INSTALL_UTILITIES   = true
INSTALL_APACHE      = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"

# Folders
HOST_FOLDER         = "./shared"
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

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	if UPGRADE_BOX
		config.vm.provision :shell, path: "provision/scripts/upgrade.sh"
	end
	if INSTALL_UTILITIES
		config.vm.provision :shell, path: "provision/scripts/utilities.sh"
	end
	if INSTALL_APACHE
		config.vm.provision :shell, path: "provision/scripts/apache.sh"
	end

end
```

## 02 Create `provision/scripts/apache.sh`:

```
#!/bin/bash

# 02 Install Apache

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

apt-get update
apt-get install -y apache2

yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

a2ensite local.conf
a2dissite 000-default

a2enmod rewrite

#rm -rf /var/www/html

sudo a2enmod ssl
sudo service apache2 restart
```

## 03 Run:

```
vagrant reload --provision
```

*Or...* for a more nuclear approach:

```
vagrant destroy
vagrant up
```

* When finished, visit [http://192.168.42.100/](http://192.168.42.100/).
* You should see the Apache default page of your VM.

### 03a **Optionally** edit `HOST_FOLDER/html/index.html`:

```
<html>
<head>
	<title>Awesome Test Project</title>
</head>
<body>
	<p><b>Shaka Bom!</b></p>
	<p>How cool is this?</p>
</body>
</html>
```
The page is a simple `index.html` located within your VM in the `/var/www/html` directory, the so-called document root. This document root is the directory that's available from the outside to your server.

## 04 All good?

Save the moment with a snapshot...

```
vagrant halt
vagrant snapshot push
vagrant up
```

--

<!-- 02 Install Apache -->
| [01 Create Virtual Machine](./Create_Virtual_Machine.md)
| [**Back to Steps**](../README.md)
| [03 Install PHP](./Install_PHP.md)
|