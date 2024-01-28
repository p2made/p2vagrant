# 07 Install Composer

--

### Create `provision/scripts/install_composer.sh`

```
#!/bin/sh

# 07 Install Composer

# Variables...
# NONE!"

# Function for error handling
handle_error() {
    echo "⚠️ Error: $1 💥"
    exit 1
}

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🚀 Installing Composer 🚀"
echo "📜 Script Name:  install_composer.sh"
echo "📅 Last Updated: 2024-01-20"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

export DEBIAN_FRONTEND=noninteractive

export DEBIAN_FRONTEND=noninteractive

# Download and install Composer
if ! curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer; then
    handle_error "Failed to install Composer"
fi

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 Composer Installed ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 07 Install Composer
# Updated: 2024-01-20

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.3"

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
	config.vm.provision :shell, path: "provision/scripts/02_upgrade_vm.sh"
	config.vm.provision :shell, path: "provision/scripts/03_install_utilities.sh", args: [TIMEZONE]
	config.vm.provision :shell, path: "provision/scripts/04_generate_ssl.sh", args: [SSL_DIR, CERT_NAME]
	config.vm.provision :shell, path: "provision/scripts/04_install_apache.fish"
	config.vm.provision :shell, path: "provision/scripts/05_install_php.fish", args: [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_composer.sh"

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_07 ./Vagrantfile
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

| [06 Install PHP](./06_Install_PHP.md)
| [**Back to Steps**](../README.md)
| [08 Install MySQL](./08_Install_MySQL.md)
|
