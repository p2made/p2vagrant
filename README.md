# P2Vagrant

My Vagrant on macOS journey.

--

To use this at the stage of development that you find it...

1. Either open the project in Github Desktop or download & unpack the zip file.
2. In Terminal cd intom the project directory & run...

```
vagrant up
```

## Steps Taken

Following are the steps taken to get to where I am. Because it's primarily for self-consumption explanations are little if any.

1. [Creating the Virtual Machine](#step_1)
2. [Install Apache](#step_2)

* [Vagrant Commands](#commands)

### <a id="step_1"></a> 1. Creating the Virtual Machine

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

### <a id="step_2"></a> 2. Install Apache

Vagrantfile:

```
Vagrant.configure("2") do |config|
	config.vm.box = "hashicorp/bionic64"

	# Give our VM a name so we immediately know which box this is when opening VirtualBox, and spice up our VM's resources
	config.vm.provider "virtualbox" do |v|
		v.name = "My Amazing Test Project"
		v.memory = 4096
		v.cpus = 1
	end

	# Choose a custom IP so this doesn't collide with other Vagrant boxes
	config.vm.network "private_network", ip: "192.168.88.188"

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/components/apache.sh"
end
```

`provision/components/apache.sh`:

```
#!/bin/bash

apt-get update
apt-get install -y apache2
```

Run (see [commands](#commands)):

```
vagrant reload --provision
```

*But*, that name is more completely applied if the Vagrant box is destroyed & created again:

```
vagrant destroy
vagrant up
```






## <a id="commands"></a> Vagrant Commands

Command | Result
------- | ------
`vagrant up` | Starts the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant halt` | Stops the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant reload` | Re-runs your Vagrantfile, so used for changes in your `Vagrantfile`.
`vagrant provision` | Re-runs your configured provisioners, so only used if you've changed any of them, or added new ones to the `Vagrantfile`.
`vagrant reload --provision` | Re-runs your `Vagrantfile` **and** your provisioners, so used if there were changes in both files.
`vagrant destroy` | Destroys the Vagrant box specified by the `Vagrantfile ` in the current directory.

