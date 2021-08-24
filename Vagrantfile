# -*- mode: ruby -*-
# vi: set ft=ruby :

# Give our VM a name so we immediately know which box this is when opening VirtualBox
PROJECT_NAME        = "Amazing Test Project"
# Spice up our VM's resources
MEMORY              = 4096
CPUS                = 1
# Choose a custom IP so this doesn't collide with other Vagrant boxes
IP                  = "192.168.88.188"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: IP

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/apache.sh"

end
