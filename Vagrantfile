# -*- mode: ruby -*-
# vi: set ft=ruby :

# 05 Install MySQL 8.1

INSTALL_APACHE      = true
INSTALL_PHP         = true
INSTALL_MYSQL       = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
# Folders
HOST_FOLDER         = "./shared"
REMOTE_FOLDER       = "/var/www"
# Software Versions
PHP_VERSION         = "8.2"
MYSQL_VERSION       = "8.1"
PHPMYADMIN_VERSION  = "5.2.1"
# Database Variables
RT_PASSWORD         = "Pa$$w0rd0ne"
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Pa$$w0rdTw0"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"

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
	if INSTALL_APACHE = true
		config.vm.provision :shell, path: "provision/scripts/apache.sh"
	end
	if INSTALL_PHP = true
		config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	end
	if INSTALL_PHP = true
		config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	end

end
