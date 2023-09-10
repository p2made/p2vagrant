# -*- mode: ruby -*-
# vi: set ft=ruby :

# 05 Install phpMyAdmin

UPGRADE_BOX         = true
INSTALL_UTILITIES   = true
INSTALL_APACHE      = true
INSTALL_PHP         = true
INSTALL_MYSQL       = true
#INSTALL_PHPMYADMIN  = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"
SSH_PASSWORD        = 'vagrant'

# Folders
HOST_FOLDER         = "./shared"
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.2"
MYSQL_VERSION       = "8.1"
PHPMYADMIN_VERSION  = "5.2.1"

# Database Variables
RT_PASSWORD         = "Passw0rd0ne"
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rdTw0"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"
PMA_PASSWORD        = "PM4Passw0rd"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

		config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
		config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Provisioning...
	if UPGRADE_BOX
		config.vm.provision :shell, path: "provision/scripts/upgrade.sh"
	end
	if INSTALL_UTILITIES
		config.vm.provision :shell, path: "provision/scripts/utilities.sh"
	end
	if INSTALL_APACHE
		config.vm.provision :shell, path: "provision/scripts/apache.sh"
	end
	if INSTALL_PHP
		config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	end
	if INSTALL_MYSQL
		config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	end
#	if INSTALL_PHPMYADMIN
#		config.vm.provision :shell, path: "provision/scripts/phpmyadmin.sh", :args => [PHPMYADMIN_VERSION, PMA_PASSWORD, REMOTE_FOLDER]
#	end

end
