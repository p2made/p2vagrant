# 04 Upgrade VM (revisited)

Updated: 2024-02-12

--

### Create `provision/scripts/upgrade_vm.fish`

```
#!/bin/fish

# 04 Upgrade VM (revisited)

set script_name     "upgrade_vm.fish"
set updated_date    "2024-02-12"

set active_title    "Upgrading VM"
set job_complete    "Upgrade completed successfully"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Arguments...
# NONE!

# Script variables...
# NONE!

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	package1 \
	package2

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to upgrade package with error handling
# Usage: upgrade_packages
function upgrade_packages
	echo "⬆️ Upgrading packages ⬆️"

	# Check if there are packages to upgrade
	if not apt-get -s upgrade | grep -q '^[[:digit:]]\+ upgraded'
		announce_no_job "No packages to upgrade."
		return
	end

	# Actually perform the upgrade
	if not apt-get -qy upgrade > /dev/null 2>&1
		handle_error "Failed to upgrade packages"
	end

	announce_success "Packages successfully upgraded."
end

# Function to remove unnecessary packages
# Usage: remove_unnecessary_packages
function remove_unnecessary_packages
	if not apt-get autoremove --dry-run | grep -q '^[[:digit:]]\+ packages will be removed'
		announce_no_job "No unnecessary packages to remove."
		return
	end

	echo "🧹 Removing unnecessary packages 🧹"

	if not apt-get -qy autoremove
		handle_error "Failed to remove unnecessary packages"
	end

	announce_success "Unnecessary packages removed."
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function advance_vm
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	set -x DEBIAN_FRONTEND noninteractive

	update_package_lists
	upgrade_packages
	remove_unnecessary_packages

	# Display OS information
	echo "📄 Displaying OS information 📄"
	cat /etc/os-release

	announce_success "System update complete! ✅"

	# Footer banner
	footer_banner "$job_complete"
end

advance_vm
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 04 Upgrade VM (revisited)
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

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", args: [VM_HOSTNAME], run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh"

end
```

Or run...

```
./vg 4
```

### Provision the VM...

**Not this time‼️** `run: "always"`, means the script will run every time `vagrant up` is run. If you don't want it running, comment the line out.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 04 Upgrade VM (revisited) -->
| [03 Install Utilities](./03_Install_Utilities.md)
| [**Back to Steps**](../README.md)
| [05 Install Swift (optional)](./05_Install_Swift.md)
|
