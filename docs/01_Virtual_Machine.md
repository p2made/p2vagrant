# 1. Creating the Virtual Machine

--

Vagrantfile:

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
* [Back to Steps](../Steps_Taken.md)
* [Installing Apache](./02_Apache.md)
