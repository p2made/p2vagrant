# 03 Install Utilities

**Updated:** 2024-01-27

--

### Create `provision/scripts/03_install_utilities.sh`

```
#!/bin/bash

# 03 Install Utilities

# Variables...
# 1 - TIMEZONE   = "Australia/Brisbane"

# Get the last modified date dynamically
last_modified_date=$(date -r "$0" "+%Y-%m-%d")

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing Utilities 🚀"
echo "🇺🇿    📜 Script Name:  03_install_utilities.sh"
echo "🇹🇲    📅 Last Updated: $last_modified_date"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Function for error handling
# Usage: handle_error "Error message"
handle_error() {
	echo "⚠️ Error: $1 💥"
	echo "Run `vagrant halt` then restore the last snapshot before trying again."
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully."
announce_success() {
	echo "✅ $1"
}

export DEBIAN_FRONTEND=noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to install packages with progress dots and error handling
install_packages() {
	echo "🔄 Installing packages 🔄"

	# Run apt-get in a subshell to capture its output
	(
		while IFS= read -r line; do
			echo -n "🐌"
		done < <(apt-get -qy install "$@" 2>&1)
		echo ""  # Move to the next line after the dots
	)

	if [ "${PIPESTATUS[0]}" -ne 0 ]; then
		handle_error "Failed to install packages"
	fi

	announce_success "Utilities Installation: Packages installed successfully!"
}

update_package_lists() {
	echo "🔄 Updating package lists 🔄"
	if ! apt-get -q update 2>&1; then
		handle_error "Failed to update package lists"
	fi
}

# Function to set Fish as the default shell
set_fish_as_default_shell() {
	if ! sudo usermod -s /usr/bin/fish vagrant; then
		handle_error "Failed to set Fish shell as default"
	fi

	sudo chsh -s /usr/bin/fish vagrant

	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

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
	nodejs \
	npm \
	openssl \
	software-properties-common \
	unzip \
	yarn

set_fish_as_default_shell

# Append the 'cd /var/www' line to .profile if it doesn't exist
grep -qxF 'cd /var/www' /home/vagrant/.profile || \
	echo 'cd /var/www' >> /home/vagrant/.profile

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 Utilities Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 03 Install Utilities
# Updated: 2024-01-26

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
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

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/02_upgrade_vm.sh"
	config.vm.provision :shell, path: "provision/scripts/03_install_utilities.sh", args: [TIMEZONE]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_03 ./Vagrantfile
```

* **Note:** From here on, all but the last provisioning script call will be commented out. If you want to run more than one step at once, simply uncomment the earlier lines.

### Provision the VM...

If the VM is running

```
vagrant reload --provision
```

If the VM is **not** running

```
vagrant up --provision
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [02 Upgrade VM](./02_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [04 Generate SSL](./04_Generate_SSL.md)
|
