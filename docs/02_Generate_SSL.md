# 2. Generate SSL

--

* Start using variables so all the customisation is in one place.

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Awesome Test Project"
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
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

# Hosts - never empty these variables, but replace them if you need additional hostnames
HOST_0              = "example.localhost"
HOST_1              = "example1.localhost"
HOST_2              = "example2.localhost"
HOST_3              = "example3.localhost"
HOST_4              = "example4.localhost"

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
	config.vm.provision :shell, path: "provision/scripts/ssl.sh", :args => [HOST_0, HOST_1, HOST_2, HOST_3, HOST_4]

end
```

Create `provision/scripts/apache.sh`:

```
#!/bin/bash

sed -i.bak 's/^[^#]*BBB/#&/' /etc/ssl/openssl.cnf

if [ ! -f /var/www/provision/config/ssl/local.key ]; then
  openssl req -x509 \
    -newkey rsa:4096 \
    -sha256 \
    -days 730 \
    -nodes \
    -keyout /var/www/provision/config/ssl/local.key \
    -out /var/www/provision/config/ssl/local.crt \
    -subj "/CN=$1" \
    -addext "subjectAltName=DNS:$1,DNS:$2,DNS:$3,DNS:$4,DNS:$5,DNS:*.$1,DNS:*.$2,DNS:*.$3,DNS:*.$4,DNS:*.$5,IP:10.0.0.1"
fi
```

Run:

```
vagrant reload --provision
```

--
* [Install Apache](./03_Install_Apache.md)
* [Back to Steps](./00_Steps.md)
