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

1. [Create the Virtual Machine](#step_01)
2. [Install Apache](#step_02)

* [Vagrant Commands](#commands)

--

### <a id="step_01"></a> 1. Create the Virtual Machine

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

### <a id="step_02"></a> 2. Install Apache

Vagrantfile:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Give our VM a name so we immediately know which box this is when opening VirtualBox
PROJECT_NAME        = "Amazing Test Project"
# Spice up our VM's resources
MEMORY              = 4096
CPUS                = 1
# Choose a custom IP so this doesn't collide with other Vagrant boxes
IP                  = "192.168.88.188"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: IP

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/apache.sh"

end
```

* Start using variables so all the customisation is in one place.

Create `provision/scripts/apache.sh`:

```
#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

sudo apt-get update
sudo apt-get install -y apache2
```

Run:

```
vagrant reload --provision
```

*But*, that name is more completely applied if the Vagrant box is destroyed & created again:

```
vagrant destroy
vagrant up
```

* When finished, visit [http://192.168.88.188/](http://192.168.88.188/).
* You should see the Apache default page of your VM.

The page is a simple `index.html` located within your VM in the `/var/www/html` directory, the so-called document root. This document root is the directory that's available from the outside to your server.















--

## <a id="commands"></a> Vagrant Commands

Command | Result
------- | ------
`vagrant up` | Starts the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant halt` | Stops the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant reload` | Re-runs your Vagrantfile, so used for changes in your `Vagrantfile`. Same as running `vagrant halt` then `vagrant up`.
`vagrant provision` | Re-runs your configured provisioners, so only used if you've changed any of them, or added new ones to the `Vagrantfile`.
`vagrant reload --provision` | Re-runs your `Vagrantfile` **and** your provisioners, so used if there were changes in both files.
`vagrant destroy` | Destroys the Vagrant box specified by the `Vagrantfile ` in the current directory.
`vagrant ssh` | SSH into the Vagrant box.

