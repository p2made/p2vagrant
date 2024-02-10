# 07 Upgrade VM (revisited)

Updated: 2024-02-03

--

### Create `provision/scripts/upgrade_vm.fish`

```
#!/bin/fish

# 04 Upgrade VM (revisited)

set script_name     "upgrade_vm.fish"
set updated_date    "2024-02-03"

set active_title    "Upgrading VM"
set job_complete    "Upgrade completed successfully"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# NONE!"

# Script constants...

# GENERATION_DATE     $(date "+%Y-%m-%d")
# VM_FOLDER           /var/www
# SHARED_HTML          $VM_FOLDER/html
# PROVISION_FOLDER    $VM_FOLDER/provision
# PROVISION_DATA      $VM_FOLDER/provision/data
# PROVISION_HTML      $VM_FOLDER/provision/html
# PROVISION_LOGS      $VM_FOLDER/provision/logs
# PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
# PROVISION_SSL       $VM_FOLDER/provision/ssl
# PROVISION_TEMPLATES $VM_FOLDER/provision/templates
# PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

# Script variables...

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	package1 \
	package2

# Script functions...

# Function for error handling
# Usage: handle_error "Error message"

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]

# Function to update package with error handling
# Usage: update_package_lists

# Function to install packages with error handling
# Usage: install_packages $package_list

# Function to update package lists the install packages with error handling
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list

set -x DEBIAN_FRONTEND noninteractive

# Start _script_title_ logic...

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Custom functions

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job
	echo "👍 $argv[1]"
end

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

update_package_lists
upgrade_packages
remove_unnecessary_packages

# Display OS information
echo "📄 Displaying OS information 📄"
cat /etc/os-release

announce_success "System update complete! ✅"

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 04 Upgrade VM (revisited)
# Generated: 2024-02-11

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

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
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", args: [VM_HOSTNAME], run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh"

end
```

Or run..

```
./provision/scripts/vg.sh 4
```

### Provision the VM...

Not this time. `run: "always"`, means the script will run every time `vagrant up` is run. If you don't want it running, connent the line out.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 04 Upgrade VM (revisited) -->
| [03 Install Utilities](./03_Install_Utilities.md)
| [**Back to Steps**](../README.md)
| [05 Install Apache (with SSL)](./05_Install_Apache.md)
|
