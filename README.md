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
2. [Pre-Provisioning](#step_02)
2. [Install Apache](#step_03)
4. [Synced Folder](#step_04)
4. [Install PHP 8.0](#step_05)
4. [Level Up PHP](#step_06)

* [Vagrant Commands](#commands)

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

### <a id="step_02"></a> 2. Pre-Provisioning

A repository by Ondřej Surý ([https://launchpad.net/~ondrej/+archive/ubuntu/php/](https://launchpad.net/~ondrej/+archive/ubuntu/php/)) that allows us to install newer versions of PHP on the LTS versions of Ubuntu.

To get the Ondřej repository setup we need to run the commands below to install the prerequisite packages and then add the repository.

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/prevision.sh"

end
```

Create `provision/scripts/prevision.sh`:

```
#!/bin/bash

sudo apt-get update
sudo apt-get install -y lsb-release ca-certificates apt-transport-https software-properties-common
sudo add-apt-repository ppa:ondrej/php

# language bug workaround
sudo apt-get install -y language-pack-en-base
sudo export LC_ALL=en_AU.UTF-8
sudo export LANG=en_AU.UTF-8
sudo apt-get install -y software-properties-common
```

Run (see [commands](#commands)):

```
vagrant provision
```


### <a id="step_03"></a> 3. Install Apache

Vagrantfile:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

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
	config.vm.provision :shell, path: "provision/scripts/prevision.sh"
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
end
```

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

### <a id="step_04"></a> 4. Synced Folder

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

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

	# Set a synced folder
	config.vm.synced_folder ".", "/var/www", create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/prevision.sh"
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
end
```

What this does is link our whole project folder to the `/var/www/` directory on our VM. Replace `"."` with `"path/to/folder"` if you want to sync to another folder.

Create `synced/html/index.html`:

```
<html>
<head>
	<title>Wassup</title>
</head>
<body>
	<p>How cool is this?</p>
</body>
</html>
```

Run:

```
vagrant reload
```

* When finished, refresh the page.

### <a id="step_05"></a> 5. Install PHP 8.0

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

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

	# Set a synced folder
	config.vm.synced_folder ".", "/var/www", create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/scripts/prevision.sh"
	config.vm.provision :shell, path: "provision/scripts/apache.sh"
	config.vm.provision :shell, path: "provision/scripts/php.sh"
end
```

Create `provision/scripts/php.sh`:

```
#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php8.0 php8.0-mysql

sudo service apache2 restart
```

Create `synced/html/phpinfo.php`:

```
<?php
phpinfo();
```

Run:

```
vagrant provision
```

* When finished, r* When finished, refresh the page.
visit [http://192.168.88.188/phpinfo.php](http://192.168.88.188/phpinfo.php), which should successfully display the PHP info page.

### <a id="step_06"></a> 6. Level Up PHP

`provision/scripts/php.sh`:

```
#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt-get install -y php8.0 php8.0-mysql

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/8.0/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/8.0/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/8.0/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/8.0/apache2/php.ini

sudo service apache2 restart
```

Run:

```
vagrant provision
```

Refresh [http://192.168.88.188/phpinfo.php](http://192.168.88.188/phpinfo.php).

















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

