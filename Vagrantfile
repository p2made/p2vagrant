# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
	# Machine
	MEMORY              = 4096
	CPUS                = 1
	VM_IP               = "192.168.98.99"
	# Folders
	HOST_FOLDER         = "./public"
	REMOTE_FOLDER       = "/var/www"
	# Versions
	PHP_VERSION         = "8.2"

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
	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]

end
