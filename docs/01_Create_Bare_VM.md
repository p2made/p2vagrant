# 01 Create Bare VM

--

Here I create a bare VM with an ARM build of Ubuntu & `vmware_desktop` as the Vagrant provider.

The instructions given assume the use of [Homebrew](https://brew.sh). If you don't have it installed, run...

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install the VMware Fusion 2023 Tech Preview

* [This one](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-TP2023) is the most recent as of [2023-07-13](https://blogs.vmware.com/teamfusion/2023/07/vmware-fusion-2023-tech-preview.html).
* Installs `VMware Fusion Tech Preview` in your `Applications` folder.
* Rename it to `VMware Fusion` (I don't know why that's necessary, but I read that it is, & it find that is).
* Nothing needs to be set up in `VMware Fusion`.
* VMware Fusion needs to be running when you run `vagrant up`, or any other Vagrant command that starts a VM.
* Technically VMware Fusion doesn't need to be running & will be lanched by vagrant when necessary. However…
* VMware Fusion can take long enough to launch on my Mac that Vagrant times out.

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

### section_title

some_text

```
some_code
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

# 01 Create Bare VM

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

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_01 ./Vagrantfile
```

### Launch the VM:

```
vagrant up
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [00 blank](./00_blank.md)
| [**Back to Steps**](../README.md)
| [02 Upgrade VM](./02_Upgrade_VM.md)
|
