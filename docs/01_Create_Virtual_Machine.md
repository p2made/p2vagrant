# 01 Create the Virtual Machine

--

The instructions given assume the use of [Homebrew](https://brew.sh). If you don't have it installed, run...

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 01 Install the VMware Fusion 2023 Tech Preview

* [This one](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-TP2023) is the most recent as of [2023-07-13](https://blogs.vmware.com/teamfusion/2023/07/vmware-fusion-2023-tech-preview.html).
* Installs `VMware Fusion Tech Preview` in your `Applications` folder.
* Rename it to `VMware Fusion`
* (I don't know why that's necessary, but I read that it is, & it find that is).

`VMware Fusion` needs to be running when you run `vagrant up`, or any other Vagrant command that starts a VM. Nothing needs to be set up in `VMware Fusion`.

## 02 Install Vagrant & VMware Utility

```
brew install --cask vagrant
brew install --cask vagrant-vmware-utility
```

### 02a Optionally install Vagrant Manager

```
brew install --cask vagrant-manager
```

## 03 Install Vagrant Plugins

```
vagrant plugin install vagrant-share
vagrant plugin install vagrant-vmware-desktop
```

## 04 Check `vagrant` status

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

## 04 Create `Vagrantfile `

* `v.gui` needs to be set to `true`.
* `v.memory` & `v.cpus` might as well be set now.
* Same for `config.vm.network`.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 01 Create the Virtual Machine

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.255"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

end
```

## 05 Launch the VM

```
vagrant up
```

## 06 All good?

Save the moment with a snapshot...

```
vagrant halt
vagrant snapshot push
vagrant up
```

--

<!-- 01 Create the Virtual Machine -->
| [**Back to Steps**](../README.md)
| [02 Install Apache](./02_Install_Apache.md)
| [02 Create Virtual Machine](./02_Create_Virtual_Machine.md)
|
