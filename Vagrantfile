# -*- mode: ruby -*-
# vi: set ft=ruby

# 09 Install Yarn

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane"
#TIMEZONE            = "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.2"
MYSQL_VERSION       = "8.1"
PMA_VERSION         = "5.2.1"

# Database Variables
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rd"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"

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

	# Upgrade check...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: 'always'

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"
#	config.vm.provision :shell, path: "provision/scripts/install_php.sh", :args => [PHP_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_composer.sh"
#	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", :args => [MYSQL_VERSION, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
#	config.vm.provision :shell, path: "provision/scripts/install_phpmyadmin.sh", :args => [PMA_VERSION, DB_PASSWORD, REMOTE_FOLDER]
	config.vm.provision :shell, path: "provision/scripts/install_yarn.sh"

end
