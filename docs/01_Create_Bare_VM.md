# 01 Create Bare VM

Updated: 2024-02-02

--

Here I create a bare VM with an ARM build of Ubuntu & `vmware_desktop` as the Vagrant provider. In step 3 I install fish shell, & Swift. After that fish is the shell in `ssh` sessions, & provisioning scripts are in Swift (this is a Mac project after all 🙃).

The instructions given assume the use of [Homebrew](https://brew.sh). If you don't have it installed, run...

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

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

If you change nothing else in these `Vagrantfile`s, take a hard look at `VM_IP`.  That must be an IP address in the `192.168.x.x` range, that is not in use on your host Mac, or any LAN that you connect to. If you deploy more than one VM on your Mac, they **must** have different settings for `VM_IP`.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 01 Create Bare VM
# Updated: 2024-02-07

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
VM_IP               = "192.168.22.42"      # 22 = titanium, 42 = Douglas Adams's number

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

### Launch the VM

```
vagrant up
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 01 Create Bare VM -->
| [00 blank](./00_blank.md)
| [**Back to Steps**](../README.md)
| [02 Upgrade VM](./02_Upgrade_VM.md)
|
