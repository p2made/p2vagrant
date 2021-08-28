# 1. Create the VM

--

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

end
```

Run:

```
vagrant up
```

--
* [Generate SSL](./02_Generate_SSL.md)
* [Back to Steps](./00_Steps.md)
