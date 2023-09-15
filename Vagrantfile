# -*- mode: ruby -*-
# vi: set ft=ruby :

# 04 Install MySQL 8.1

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane"
#TIMEZONE            = "Europe/London"
VM_IP               = "192.168.42.100"
#SSH_PASSWORD        = 'vagrant'

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.2"
MYSQL_VERSION       = "8.1"

# Database Variables
RT_PASSWORD         = "Passw0rd0ne"
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rdTw0"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/_always_begin.sh", run: 'always'
	config.vm.provision :shell, path: "provision/scripts/_first_time.sh", args: [TIMEZONE]

	config.vm.provision :shell, path: "provision/scripts/apache.sh"
	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]

	config.vm.provision :shell, path: "provision/scripts/_always_end.sh", run: 'always'

end
