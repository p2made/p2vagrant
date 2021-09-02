# 7. Generating SSL Certificates & Keys

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
	config.vm.provision :shell, path: "provision/scripts/ssl.sh", :args => [TLD]
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/phpmyadmin.sh", :args => [PHPMYADMIN_VERSION, DB_PASSWORD, REMOTE_FOLDER]
	config.vm.provision :shell, path: "provision/scripts/sites.sh"

end
```

Create `provision/scripts/ssl.sh`:

```
#!/bin/bash

sed -i.bak 's/^[^#]*BBB/#&/' /etc/ssl/openssl.cnf

if [ ! -f /var/www/provision/apache/ssl/local.key ]; then
  openssl req -x509 \
    -newkey rsa:4096 \
    -sha256 \
    -days 730 \
    -nodes \
    -keyout /var/www/provision/apache/ssl/local.key \
    -out /var/www/provision/apache/ssl/local.crt \
    -subj "/CN=$1" \
    -addext "subjectAltName=DNS:$1,DNS:*.$1,IP:10.0.0.1"
fi
```

Run:

```
vagrant destroy
vagrant up
```

--
* [Back to Steps](../Steps_Taken.md)
* [Installing Composer](./08_Composer.md)