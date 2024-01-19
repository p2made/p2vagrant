# 06 Install Composer

--

### Create `provision/scripts/install_composer.sh`

```
#!/bin/sh

# 06 Install Composer

# Variables...
# NONE!"

echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🚀 Installing Composer 🚀"
echo "Script Name:  install_composer.sh"
echo "Last Updated: 2023-01-19"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Download and install Composer
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

echo ""
echo "⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️"
echo ""
echo "🏆 Composer Installed ‼️"
echo ""
echo "🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭 🛠️⚙️⚗️ ⚒️🗜🔭"
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 06 Install Composer

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane"
#TIMEZONE            = "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

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

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_06 ./Vagrantfile
```

### Provision the VM

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

| [05 Install PHP](./05_Install_PHP.md)
| [**Back to Steps**](../README.md)
| [07 Install MySQL](./07_Install_MySQL.md)
|
