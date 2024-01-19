# 09 Install Yarn

--

### Create `provision/scripts/install_yarn.sh`:

```
#!/bin/sh

# 09 Install Yarn

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Installing Yarn                                 #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

apt-get update && sudo apt-get -qy install yarn
```

### Update `Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 09 Install Yarn

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane"
#TIMEZONE            = "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.3"
MYSQL_VERSION       = "8.1"
PMA_VERSION         = "5.2.1"

# Database Variables
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rd"
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

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: 'always'

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"
	config.vm.provision :shell, path: "provision/scripts/install_php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_composer.sh"
	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", :args => [MYSQL_VERSION, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/install_phpmyadmin.sh", :args => [PMA_VERSION, DB_PASSWORD, REMOTE_FOLDER]
	config.vm.provision :shell, path: "provision/scripts/install_yarn.sh"

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_09 ./Vagrantfile
```

### Provision the VM:

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [08 Install phpMyAdmin](./08_Install_phpMyAdmin.md)
| [**Back to Steps**](../README.md)
| [10 Page Title](./10_Page_Title.md)
|
