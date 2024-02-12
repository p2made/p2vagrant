# 03 Install Utilities

Updated: 2024-02-12

--

### Create `provision/scripts/install_utilities.sh`

```
#!/bin/bash

# 03 Install Utilities

script_name="install_utilities.sh"
updated_date="2024-02-12"

active_title="Installing Utilities"
job_complete="Utilities Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.sh

# Arguments...
# NONE!

# Always set PACKAGE_LIST when using update_and_install_packages
PACKAGE_LIST=(
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

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to set Fish as the default shell
function set_fish_as_default_shell () {
	if ! sudo usermod -s /usr/bin/fish vagrant; then
		handle_error "Failed to set Fish shell as default"
	fi

	sudo chsh -s /usr/bin/fish vagrant

	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
}

function advance_vm () {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	# Add Fish Shell repository
	LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

	install_packages $PACKAGE_LIST

	set_fish_as_default_shell # Let's swim 🐟🐠🐟🐠🐟🐠

	# Append the 'cd /var/www' line to .profile if it doesn't exist
	grep -qxF 'cd /var/www' /home/vagrant/.profile || \
		echo 'cd /var/www' >> /home/vagrant/.profile

	# Footer banner
	footer_banner "$job_complete"
}

advance_vm
```

That function `set_fish_as_default_shell() { ... }` is just as described on the label. It sets [🐟fish🐠](https://fishshell.com) as the default shell. After this step, all the scripts will be 🐠`.fish`🐟, so let's go swimming 🏊🏊‍♀️🏊‍♂️

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 03 Install Utilities
# Generated: 2024-02-12

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
VM_FOLDER       = "/var/www"

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

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh"

end
```

Or run...

```
./vg 3
```

* **Note:** From here on, all but the last provisioning script call will be commented out. If you want to run more than one step at once, simply uncomment the earlier lines.

### Provision the VM...

If the VM is **not** running

```
vagrant up --provision
```

If the VM is running

```
vagrant reload --provision
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 03 Install Utilities -->
| [02 Upgrade VM](./02_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [04 Upgrade VM (revisited)](./04_Upgrade_VM.md)
|
