# 02 Create the Virtual Machine

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

That's it!

--

* [01 Install Software](./01_Install_Software.md)
* [**Back to Steps**](../README.md)
* [03 Install Apache](./03_Install_Apache.md)
