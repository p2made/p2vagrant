# -*- mode: ruby -*-
# vi: set ft=ruby

# 01 Create Bare VM
# Generated: 2024-03-03

# Machine Variables
VM_HOSTNAME         = ""
VM_IP               = ""
TIMEZONE            = ""
MEMORY              = 
CPUS                = 

# Synced Folders
HOST_FOLDER         = ""
VM_FOLDER           = ""

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
end
