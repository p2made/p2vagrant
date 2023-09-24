# 03 Install Utilities

--

### Create `install_utilities.sh`

```
#!/bin/sh

# 03 Install Utilities

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Installing __item__                             #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

# TIMEZONE            = "Australia/Brisbane"  | $1

timedatectl set-timezone $1 --no-ask-password

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

apt-get -qy install apt-transport-https
apt-get -qy install bzip2
apt-get -qy install ca-certificates
apt-get -qy install curl
apt-get -qy install expect
apt-get -qy install file
apt-get -qy install fish
apt-get -qy install git
apt-get -qy install gnupg2
apt-get -qy install gzip
apt-get -qy install libapr1
apt-get -qy install libaprutil1
apt-get -qy install libaprutil1-dbd-sqlite3
apt-get -qy install libaprutil1-ldap
apt-get -qy install liblua5.3-0
apt-get -qy install lsb-release
apt-get -qy install mime-support
apt-get -qy install software-properties-common
apt-get -qy install unzip

chsh -s /usr/bin/fish
grep -qxF 'cd /var/www' /home/vagrant/.profile || echo 'cd /var/www' >> /home/vagrant/.profile
```

I put each install item on its own line so that the failure of any one does't risk crashing the whole.

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 03 Install Utilities

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

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_03 ./Vagrantfile
```

### Provision the VM

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [02 Upgrade VM](./02_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [04 Install Apache](./04_Install_Apache.md)
|
