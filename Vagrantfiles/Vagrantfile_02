# -*- mode: ruby -*-
# vi: set ft=ruby :

# 02 Install PHP 8.2

UPGRADE_BOX         = true
INSTALL_UTILITIES   = true
INSTALL_PHP         = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"

# Folders
HOST_FOLDER         = "./shared"
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

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	if UPGRADE_BOX
		config.vm.provision :shell, path: "provision/scripts/upgrade.sh"
	end
	if INSTALL_UTILITIES
		config.vm.provision :shell, path: "provision/scripts/utilities.sh"
	end
	if INSTALL_PHP
		config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	end

end
