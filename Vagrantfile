# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Amazing Test Project"
MEMORY              = 4096
CPUS                = 1
IP                  = "192.168.88.188"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"
MYSQL_VERSION       = "8.0"
RT_PASSWORD         = "password"
DB_USERNAME         = "user"
DB_PASSWORD         = "password"
DB_NAME             = "db"
DB_NAME_TEST        = "db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/components/apache.sh"
	config.vm.provision :shell, path: "provision/components/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/components/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/components/phpmyadmin.sh", :args => [PHPMYADMIN_VERSION, DB_PASSWORD, REMOTE_FOLDER]

end
