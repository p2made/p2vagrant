# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
HOST_FOLDER         = "./shared"
REMOTE_FOLDER       = "/var/www"

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
	config.vm.provision :shell, path: "provision/scripts/apache.sh"

end
