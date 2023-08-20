# 2. Installing Apache

--

Vagrantfile:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Awesome Test Project"
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
TLD                 = "tld"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"
PHPMYADMIN_VERSION  = "5.1.1"
MYSQL_VERSION       = "5.7"
COMPOSER_VERSION    = "2.1.6"
RT_PASSWORD         = "password"
DB_USERNAME         = "user"
DB_PASSWORD         = "password"
DB_NAME             = "db"
DB_NAME_TEST        = "db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/apache.sh"

end
```

Create `provision/scripts/apache.sh`:

```
#!/bin/bash

LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

apt-get update
apt-get install -y apache2
```

Create `HOST_FOLDER/html/index.html`:

```
<html>
<head>
	<title>Awesome Test Project</title>
</head>
<body>
	<p><b>Shaka Bom!<b/></p>
	<p>How cool is this?</p>
</body>
</html>
```

Run:

```
vagrant reload --provision
```

*But*, that name is more completely applied if the Vagrant box is destroyed & created again:

```
vagrant destroy
vagrant up
```

* When finished, visit [http://192.168.88.188/](http://192.168.88.188/).
* You should see the Apache default page of your VM.

The page is a simple `index.html` located within your VM in the `/var/www/html` directory, the so-called document root. This document root is the directory that's available from the outside to your server.

--
* [Back to Steps](./00_Steps.md)
* [Installing PHP 8.0](./03_PHP.md)
