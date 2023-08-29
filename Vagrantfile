# -*- mode: ruby -*-
# vi: set ft=ruby :

# 05 Install MySQL 8.1

# Variables
	# Machine
	MEMORY              = 4096
	CPUS                = 1
	VM_IP               = "192.168.98.99"
	# Folders
	HOST_FOLDER         = "./shared"
	REMOTE_FOLDER       = "/var/www"
	# Versions
	PHP_VERSION         = "8.2"
	MYSQL_VERSION       = "8.1"
	# Database
	RT_PASSWORD         = "Pa$$w0rd0ne"
	DB_USERNAME         = "fredspotty"
	DB_PASSWORD         = "Pa$$w0rdTw0"
	DB_NAME             = "db"
	DB_NAME_TEST        = "db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = false
	end

	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
#	config.vm.provision :shell, path: "provision/scripts/apache.sh"
#	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

end
