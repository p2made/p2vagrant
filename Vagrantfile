# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/repo.sh"

end
