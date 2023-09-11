# 02 Install Apache

--

### Update `Vagrantfile`

Here I've started to group variables for easier following.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 02 Install Apache

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

end
```

Copy this file...

```
cp ./Vagrantfiles/Vagrantfile_02 ./Vagrantfile
```

### Create `provision/scripts/apache.sh`:

```
#!/bin/bash

# 02 Install Apache

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

apt-get update

apt-get install -y apache2 apache2-bin apache2-data apache2-utils

yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

#rm -rf /var/www/html

systemctl restart apache2
#service apache2 restart
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

Copy this file...

```
cp ./Vagrantfiles/Vagrantfile_02 ./Vagrantfile
```

The page is a simple `index.html` located within your VM in the `/var/www/html` directory, the so-called document root. This document root is the directory that's available from the outside to your server.

### All good?

Save the moment with a snapshot...

```
vagrant halt
vagrant snapshot push
vagrant up
```

--

<!-- 02 Install Apache -->
| [01 Create Virtual Machine](./01_Create_Virtual_Machine.md)
| [**Back to Steps**](../README.md)
| [03 Install PHP](./03_Install_PHP.md)
|
