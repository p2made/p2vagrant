# 02 Upgrade VM

--

Now that there's a bare Ubuntu VM…

### Create `upgrade_vm.sh`

```
#!/bin/sh

# 02 Upgrade VM

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Upgrading VM                                    #####"
echo "#####                                                       #####"
echo "#####       should always run first                         #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release
```

The `echo` lines at the top on the script (& others throughout) are to show in Terminal output which script is running. They can be removed when you're comfortable without them.

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
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: 'always'

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_02 ./Vagrantfile
```

If you don't want `upgrade_vm.sh`	 to run every time you launch the VM, either comment the line out or delete `run: 'always'`.

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
