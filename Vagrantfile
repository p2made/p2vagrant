# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Test Project"
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"
PHPMYADMIN_VERSION  = "5.1.1"
MYSQL_VERSION       = "5.7"
COMPOSER_VERSION    = "2.1.6"
RT_PASSWORD         = "password"
DB_USERNAME         = "user"
DB_PASSWORD         = "password"
DB_NAME             = "db"
DB_NAME_TEST        = "db_test"

# Hosts - never empty these variables, but replace them if you need additional hostnames
HOST_0              = "example.localhost"
HOST_1              = "example1.localhost"
HOST_2              = "example2.localhost"
HOST_3              = "example3.localhost"
HOST_4              = "example4.localhost"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

end
