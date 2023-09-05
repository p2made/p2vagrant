# -*- mode: ruby -*-
# vi: set ft=ruby :

# 01 Create the Virtual Machine

UPGRADE             = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Execute shell script(s)
	if UPGRADE
		config.vm.provision :shell, path: "provision/scripts/upgrade.sh"
	end
end
