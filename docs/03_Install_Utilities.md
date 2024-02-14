# 03 Install Utilities

--

### Create `provision/scripts/install_utilities.sh`

```
#!/bin/bash

# 03 Install Utilities

script_name="install_utilities.sh"
updated_date="2024-02-15"

active_title="Installing Utilities"
job_complete="Utilities Installed"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

# Arguments...
VM_HOSTNAME=$1      # "p2vagrant"
TIMEZONE=$2         # "Australia/Brisbane"

# Script variables...

# Always set package_list when using...
# install_packages() or update_and_install_packages()
package_list=(
	"apt-transport-https"
	"bzip2"
	"ca-certificates"
	"curl"
	"debconf-utils"
	"expect"
	"file"
	"fish"
	"git"
	"gnupg2"
	"gzip"
	"libapr1"
	"libaprutil1"
	"libaprutil1-dbd-sqlite3"
	"libaprutil1-ldap"
	"liblua5.3-0"
	"lsb-release"
	"mime-support"
	"nodejs"
	"npm"
	"openssl"
	"software-properties-common"
	"unzip"
	"yarn"
)

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to set Fish as the default shell
function set_fish_as_default_shell() {
	if ! sudo usermod -s /usr/bin/fish vagrant; then
		handle_error "Failed to set Fish shell as default"
	fi

	sudo chsh -s /usr/bin/fish vagrant

	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function provision() {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	# Set timezone
	echo "🕤  Setting timezone to $TIMEZONE 🕓"
	sudo timedatectl set-timezone "$TIMEZONE"

	# Set the hostname using hostnamectl
	echo "⚙️  Setting hostname to $VM_HOSTNAME ⚙️"
	sudo hostnamectl set-hostname "$VM_HOSTNAME"

	# Update /etc/hosts to include the new hostname
	sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$VM_HOSTNAME/" /etc/hosts

	# Add Fish Shell repository
	LC_ALL=C.UTF-8 add-apt-repository -yu ppa:fish-shell/release-3

	install_packages $package_list

	set_fish_as_default_shell # Let's swim 🐟🐠🐟🐠🐟🐠

	# Append the 'cd /var/www' line to .profile if it doesn't exist
	grep -qxF 'cd /var/www' /home/vagrant/.profile || \
		echo 'cd /var/www' >> /home/vagrant/.profile

	# Display Time Zone information
	echo "🕤  Displaying Time Zone information 🕤"
	timedatectl

	# Display hostname information
	echo "⚙️  Displaying Time Zone information ⚙️"
	hostnamectl

	# Footer banner
	footer_reboot "$job_complete"
}

provision

# Reboot the system
sudo reboot
```

That function `set_fish_as_default_shell() { ... }` is just as described on the label. It sets [🐟fish🐠](https://fishshell.com) as the default shell, so let's go swimming 🏊🏊‍♀️🏊‍♂️

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 03 Install Utilities
# Generated: 2024-02-15

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
VM_FOLDER           = "/var/www"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory    = MEMORY
		v.cpus      = CPUS
		v.gui       = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, VM_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: "always"

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [VM_HOSTNAME, TIMEZONE]

end
```

Or run...

```
./vg 3
```

### Provision the VM...

If the VM is **not** running

```
vagrant up --provision
```

If the VM is running

```
vagrant reload --provision
```

Get a ☕️, grab some 🍿, go walk the 🦮. A whole lot of dependancies get installed, so it takes a while.

### Check the VM...

A good check for this step is to simply `ssh` into the VM to see whether `fish` is actually the shell.

```
vagrant ssh
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 03 Install Utilities -->
| [02 Upgrade VM](./02_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [04 Install Swift (optional)](./04_Install_Swift.md)
|

--

p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳

--
