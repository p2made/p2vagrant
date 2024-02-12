# -*- mode: ruby -*-
# vi: set ft=ruby

# 06 Install Apache (with SSL)
# Generated: 2024-02-12

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
SWIFT_VERSION       = "5.9.2"

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
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", args: [VM_HOSTNAME], run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh"
#	config.vm.provision :shell, path: "provision/scripts/install_swift.fish", args: [SWIFT_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_apache.fish", args: [VM_HOSTNAME, VM_IP]

end
