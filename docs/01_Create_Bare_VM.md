# 01 Create Bare VM

--

Here I create a bare VM with an ARM build of Ubuntu & `vmware_desktop` as the Vagrant provider. In step 3 I install fish shell. After that fish is the shell in `ssh` sessions.

### Install VMware Fusion

Go to the [VMware Fusion evaluation page](https://www.vmware.com/au/products/fusion/fusion-evaluation.html) & click [REGISTER FOR A PERSONAL USE LICENSE](https://www.vmware.com/go/getfusionplayer). There either log in, if you already have a VMware user account, or register. Once logged in, you automatically be redirected to the download page for the VMware universal installer.

* Nothing needs to be set up in `VMware Fusion`.
* It's best to have VMware Fusion running when you run `vagrant up`, or any other Vagrant command that starts a VM.
* Technically VMware Fusion doesn't need to be running & will be lanched by vagrant when necessary. However...
* If VMware Fusion takes too long to launch, Vagrant times out.

### Install Vagrant & VMware Utility

```
brew install --cask vagrant
brew install --cask vagrant-vmware-utility
```

### Install Vagrant Plugins

```
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vmware-desktop
```

* Optionally install Vagrant Manager

```
brew install --cask vagrant-manager
```

You might find it useful 🙃

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
# vi: set ft=ruby

# 01 Create Bare VM
# Generated: 2024-02-11

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

end
```

Or run...

```
./vg 1
```

### Launch the VM

```
vagrant up
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 01 Create Bare VM -->
| [00 Getting Ready](./00_Getting_Ready.md)
| [**Back to Steps**](../README.md)
| [02 Upgrade VM](./02_Upgrade_VM.md)
|

--

p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳

--
