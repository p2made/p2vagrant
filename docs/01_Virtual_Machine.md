# 01 Creating the Virtual Machine

--

First you must...

* [Download and install the Fusion 2023 Tech Preview](https://customerconnect.vmware.com/downloads/get-download?downloadGroup=FUS-TP2023) - most recent as at 2023-08-24.

That installs `VMware Fusion Tech Preview` in your `Applications` folder. Rename it to `VMware Fusion` (I don't know wht that's necessary, but I read that it is, & it is).

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

