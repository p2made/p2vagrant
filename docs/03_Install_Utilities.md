# 03 Install Utilities

--

### Create `provision/scripts/install_utilities.sh`

```
#!/bin/sh

# 03 Install Utilities

# Variables...
# $1 - TIMEZONE	 = "Australia/Brisbane"

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🚀 Installing Utilities 🚀"
echo "Script Name:  install_utilities.sh"
echo "Last Updated: 2024-01-20"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Function to install packages with error handling
install_packages() {
	if ! apt-get -qy install "$@"; then
		echo "⚠️ Error: Failed to install packages 💥"
		exit 1
	fi
}

# Function to update package lists
echo "🔄 Updating package lists 🔄"
if ! apt-get -q update; then
	handle_error "⚠️ Failed to update package lists"
fi

# Set timezone
echo "🕤 Setting timezone to $1 🕓"
timedatectl set-timezone $1 --no-ask-password

# Add Fish Shell repository
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

# Call the function with the packages you want to install
install_packages \
	apt-transport-https \
	bzip2 \
	ca-certificates \
	curl \
	debconf-utils \
	expect \
	file \
	fish \
	git \
	gnupg2 \
	gzip \
	libapr1 \
	libaprutil1 \
	libaprutil1-dbd-sqlite3 \
	libaprutil1-ldap \
	liblua5.3-0 \
	lsb-release \
	mime-support \
	openssl \
	software-properties-common \
	unzip

echo ""
echo "✅ Utilities Installation: Packages installed successfully!"
echo ""

chsh -s /usr/bin/fish
grep -qxF 'cd /var/www' /home/vagrant/.profile || echo 'cd /var/www' >> /home/vagrant/.profile

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo ""
echo "🏆 Utilities Installed ‼️"
echo ""
echo "🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 03 Install Utilities
# Updated: 2024-01-20

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

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_03 ./Vagrantfile
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

| [02 Upgrade VM](./02_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [04 Generate SSL](./04_Generate_SSL.md)
|
