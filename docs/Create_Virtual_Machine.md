# 01 Create Virtual Machine

--

The instructions given assume the use of [Homebrew](https://brew.sh). If you don't have it installed, run...

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install the VMware Fusion 2023 Tech Preview

* [This one](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-TP2023) is the most recent as of [2023-07-13](https://blogs.vmware.com/teamfusion/2023/07/vmware-fusion-2023-tech-preview.html).
* Installs `VMware Fusion Tech Preview` in your `Applications` folder.
* Rename it to `VMware Fusion`
* (I don't know why that's necessary, but I read that it is, & it find that is).

`VMware Fusion` needs to be running when you run `vagrant up`, or any other Vagrant command that starts a VM. Nothing needs to be set up in `VMware Fusion`.

### Install Vagrant & VMware Utility

```
brew install --cask vagrant
brew install --cask vagrant-vmware-utility
```

#### Optionally install Vagrant Manager

```
brew install --cask vagrant-manager
```

### Install Vagrant Plugins

```
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vmware-desktop
```

### Check `vagrant` status

```
vagrant global-status
```

For result something like...

```
id       name   provider state  directory
--------------------------------------------------------------------
There are no active Vagrant environments on this computer! Or,
you haven't destroyed and recreated Vagrant environments that were
started with an older version of Vagrant.
```

### Create `Vagrantfile`

* `v.gui` needs to be set to `true`.
* `v.memory` & `v.cpus` might as well be set now.
* Same for `config.vm.network`.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 01 Create Virtual Machine

UPGRADE_BOX         = true

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"

# Folders
HOST_FOLDER         = "./shared"
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
	config.vm.provision :shell, path: "provision/scripts/upgrade.sh"
	config.vm.provision :shell, path: "provision/scripts/utilities.sh"
end
```

Copy this file...

```
cp ./Vagrantfiles/Vagrantfile_01 ./Vagrantfile
```

### Create `upgrade.sh`

```
#!/bin/bash

# 01a Upgrade

apt-get update

apt-get -y upgrade
apt-get autoremove

cat /etc/os-release
```

### Create `utilities.sh`

```
#!/bin/bash

# 01b Install Utilities

apt-add-repository ppa:fish-shell/release-3

apt-get update

apt-get install -y apt-transport-https bzip2 ca-certificates curl file fish gnupg2 libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap liblua5.3-0 lsb-release mime-support software-properties-common unzip

# Make Fish default
chsh -s /usr/bin/fish
```

### Launch the VM

```
vagrant up
```

### All good?

Save the moment with a snapshot...

```
vagrant halt
vagrant snapshot push
vagrant up
```

--

<!-- 01 Create the Virtual Machine -->
| [**Back to Steps**](../README.md)
| [02 Install Apache](./Install_Apache.md)
|
