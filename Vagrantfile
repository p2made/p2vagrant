# -*- mode: ruby -*-
# vi: set ft=ruby

# 05 Install Apache (with SSL & Markdown)
# Generated: 2024-02-14

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
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_swift.sh", args: [SWIFT_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_apache.sh", args: [VM_HOSTNAME]

end
