# 6. Setting up Domain Name(s)

--

To get this working our Ubuntu server will need a custom Virtual Host file. Again, we're not going to create it directly on our VM and make every user to the same thing, we're going to automate this. Lets first create the Virtual Host file within our project: `provision/config/apache/vhosts/example.tld.conf`

```
<VirtualHost *:80>
	ServerName example.tld
	ServerAlias www.example.tld

	DocumentRoot /var/www/path/to/root

	<Directory /var/www/path/to/root>
		# Allow .htaccess rewrite rules
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>
```

Add an additional block for each subdomain:

```
<VirtualHost *:80>
	ServerName subdomain.example.tld

	DocumentRoot /var/www/path/to/root

	<Directory /var/www/path/to/root>
		# Allow .htaccess rewrite rules
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>
</VirtualHost>
```

Vagrantfile:

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
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/phpmyadmin.sh", :args => [PHPMYADMIN_VERSION, DB_PASSWORD, REMOTE_FOLDER]
	config.vm.provision :shell, path: "provision/scripts/sites.sh"

end
```

Create `provision/scripts/sites.sh`:

```
#!/bin/bash

yes | cp /var/www/provision/apache/vhosts/* /etc/apache2/sites-available/

a2ensite example.tld.conf
a2ensite example1.tld.conf
a2ensite example2.tld.conf
a2ensite example3.tld.conf
a2ensite example4.tld.conf

sudo service apache2 restart
```

With a `a2ensite` entry for each `.conf` file.

Run:

```
vagrant provision
```

While all scripts are being executed edit the `hosts` file on your computer (on Mac, it's `/etc/hosts`) and add entries for each `ServerName` and `ServerAlias` in your `.conf` files:

```
192.168.98.99	example.tld
192.168.98.99	www.example.tld
```


--
* [Back to Steps](../Steps_Taken.md)
* [Generating SSL Certificates & Keys](./07_SSL.md)
