# 02 Upgrade VM

Updated: 2024-02-14

--

### Create `provision/scripts/upgrade_vm.sh`

```
#!/bin/bash

# 02 Upgrade VM

script_name="upgrade_vm.sh"
updated_date="2024-02-14"

active_title="Upgrading VM"
job_complete="Upgrade completed successfully"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

# Arguments...
# NONE!

# Script variables...
# NONE!

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function advance_vm () {
	# Header banner
	upgrade_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	update_package_lists
	upgrade_packages
	remove_unnecessary_packages

	# Display OS information
	echo "📄 Displaying OS information 📄"
	cat /etc/os-release

	announce_success "System update complete! ✅"

	# Footer banner
	footer_banner "$job_complete"
}

advance_vm
```

That's nice & short because I've put everything that could be reused into a [Common Functions](./Common_Functions.md) include file, `provision/scripts/_common.sh`

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 02 Upgrade VM
# Generated: 2024-02-14

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

end
```

Or run...

```
./vg 2
```

### Provision the VM...

If the VM is **not** running

```
vagrant up
```

If the VM is running

```
vagrant reload
```

‼️ `run: "always"`, means the script will run every time `vagrant up` is run. If you don't want it running, comment the line out. That's also why `--provision` isn't needed here.

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 02 Upgrade VM -->
| [01 Create Bare VM](./01_Create_Bare_VM.md)
| [**Back to Steps**](../README.md)
| [03 Install Utilities](./03_Install_Utilities.md)
|
