# -*- mode: ruby -*-
# vi: set ft=ruby :

# 04 Install PHP 8.2

INSTALL_APACHE      = true
INSTALL_PHP         = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
# Folders
HOST_FOLDER         = "./shared"
REMOTE_FOLDER       = "/var/www"
# Software Versions
PHP_VERSION         = "8.2"

puts "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
puts "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
puts "##### #####                                                                   ##### #####"
puts "##### #####           Virtual Machine, with...                                ##### #####"
puts "##### #####               INSTALL_APACHE      = true                          ##### #####"
puts "##### #####               INSTALL_PHP         = true                          ##### #####"
puts "##### #####                                                                   ##### #####"
puts "##### #####               MEMORY              = 4096                          ##### #####"
puts "##### #####               CPUS                = 1                             ##### #####"
puts "##### #####               VM_IP               = \"192.168.98.99\"               ##### #####"
puts "##### #####                                                                   ##### #####"
puts "##### #####               HOST_FOLDER         = \"./shared\"                    ##### #####"
puts "##### #####               REMOTE_FOLDER       = \"/var/www\"                    ##### #####"
puts "##### #####                                                                   ##### #####"
puts "##### #####               PHP_VERSION         = \"8.2\"                         ##### #####"
puts "##### #####                                                                   ##### #####"
puts "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
puts "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	if INSTALL_APACHE
		config.vm.provision :shell, path: "provision/scripts/apache.sh"
	end
	if INSTALL_PHP
		config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	end

end
