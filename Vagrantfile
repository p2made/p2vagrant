# -*- mode: ruby -*-
# vi: set ft=ruby

# 09 Configure Sites
# Generated: 2024-02-26

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
VM_FOLDER           = "/var/www"

# Software Versions
SWIFT_VERSION       = "5.9.2"
PHP_VERSION         = "8.3"
MYSQL_VERSION       = "8.3"

# Database Variables
ROOT_PASSWORD       = "RootPassw0rd"
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rd"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory    = MEMORY
		v.cpus      = CPUS
		v.gui       = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, VM_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [VM_HOSTNAME, TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_swift.sh", args: [SWIFT_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"
#	config.vm.provision :shell, path: "provision/scripts/install_php.sh", args: [PHP_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/configure_sites.sh"

end
