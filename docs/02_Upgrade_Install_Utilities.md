# 02 Upgrade & Install Utilities

Now that there's a bare Ubuntu VM…

### Install Vagrant & VMware Utility

```
brew install --cask vagrant
brew install --cask vagrant-vmware-utility
```

#### Optionally install Vagrant Manager

```
brew install --cask vagrant-manager
```

You might find it useful 🙃

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

### Create `_vm_start.sh`

```
#!/bin/sh

# 00 Always at Start of VM Loading

apt-get -q update
apt-get -qy upgrade
apt-get autoremove
cat /etc/os-release
```

### Create `install_utilities.sh`

```
#!/bin/sh

# 01 Install Utilities

# TIMEZONE            = "Australia/Brisbane"  | $1

timedatectl set-timezone $1 --no-ask-password

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

apt-get -qy install apt-transport-https bzip2 ca-certificates curl expect file fish git gnupg2 gzip libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap liblua5.3-0 lsb-release mime-support software-properties-common unzip

chsh -s /usr/bin/fish
echo 'cd /var/www' >> /home/vagrant/.profile
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 02 Upgrade & Install Utilities

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

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]

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

<!-- 02 Upgrade & Install Utilities -->
| [01 Create Bare VM](./01_Create_Bare_VM.md)
| [**Back to Steps**](../README.md)
| [03 Install Apache](./03_Install_Apache.md)
|
