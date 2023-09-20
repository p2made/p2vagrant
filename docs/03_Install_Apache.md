# 03 Install Apache
--

### Create `provision/scripts/apache.sh`:

```
#!/bin/sh

# 03 Install Apache

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

apt-get update

apt-get -qy install apache2 apache2-bin apache2-data apache2-utils

yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

#rm -rf /var/www/html

service apache2 restart
#systemctl restart apache2
```

### Update `Vagrantfile`


```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 03 Install Apache

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"

# Synced Folders
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
	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_03 ./Vagrantfile
```

### Run:

```
vagrant reload --provision
```

*Or...* for a more nuclear approach:

```
vagrant destroy
vagrant up
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

--

<!-- 03 Install Apache -->
| [02 Upgrade & Install Utilities](./02_Upgrade_Install_Utilities.md)
| [**Back to Steps**](../README.md)
| [04 Install PHP (& Composer)](./04_Install_PHP.md)
|