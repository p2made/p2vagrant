# 01 Creating the Virtual Machine

--

First you must download & install the [VMware Fusion 2023 Tech Preview](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-TP2023) - most recent as of [2023-07-13](https://blogs.vmware.com/teamfusion/2023/07/vmware-fusion-2023-tech-preview.html).

* That installs `VMware Fusion Tech Preview` in your `Applications` folder.
* Rename it to `VMware Fusion`
* (I don't know why that's necessary, but I read that it is, & it find that is).

--

### `Vagrantfile`:

* `v.gui` needs to be set to `true`.
* `v.memory` & `v.cpus` might as well be set now.
* Same for `config.vm.network`.

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.98.99"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

	config.vm.network "private_network", ip: VM_IP

end
```

### Run:

```
vagrant up
```

--

* [**Back to Steps**](../README.md)
* [02 Apache](./02_Apache.md)
