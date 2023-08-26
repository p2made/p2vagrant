# 02 Installing Apache

--

### `Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
HOST_FOLDER         = "./shared"
REMOTE_FOLDER       = "/var/www"

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

end
```

**Create** `provision/scripts/apache.sh`:

```
#!/bin/bash

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

apt-get update
apt-get install -y apache2

a2ensite local.conf
a2dissite 000-default

a2enmod rewrite
sudo service apache2 restart

sudo a2enmod ssl
sudo service apache2 restart
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

* When finished, visit [http://192.168.98.99/](http://192.168.98.99/).
* You should see the Apache default page of your VM.

**Optionally** edit `HOST_FOLDER/html/index.html`:

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

--

* [01 Virtual Machine](./01_Virtual_Machine.md)
* [**Back to Steps**](../README.md)
* [03 Install PHP](./04_Install_PHP.md)
