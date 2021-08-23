# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "hashicorp/bionic64"

	# Give our VM a name so we immediately know which box this is when opening VirtualBox, and spice up our VM's resources
	config.vm.provider "virtualbox" do |v|
		v.name = "Our amazing test project"
		v.memory = 4096
		v.cpus = 1
	end

	# Choose a custom IP so this doesn't collide with other Vagrant boxes
	config.vm.network "private_network", ip: "192.168.88.188"

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/repo.sh"
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
end
