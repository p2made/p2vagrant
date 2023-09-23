# 02 Upgrade VM

--

Now that there's a bare Ubuntu VM…

### Create `_vm_start.sh`

```
#!/bin/sh

# 02 Upgrade VM

echo "Update & upgrade..."
apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 02 Upgrade VM

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
	config.vm.provision :shell, path: "provision/scripts/_vm_start.sh", run: 'always'

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_02 ./Vagrantfile
```

### Launch the VM

```
vagrant up
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 02 Upgrade VM -->
| [01 Create Bare VM](./01_Create_Bare_VM.md)
| [**Back to Steps**](../README.md)
| [03 Install Utilities](./03_Install_Utilities.md)
|
