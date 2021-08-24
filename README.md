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
3. [Install PHP 8.0](#step_03)
4. [Install MySQL](#step_04)

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

* Start using variables so all the customisation is in one place.

Vagrantfile:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Amazing Test Project"
MEMORY              = 4096
CPUS                = 1
IP                  = "192.168.88.188"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/components/apache.sh"

end
```

Create `provision/components/apache.sh`:

```
#!/bin/bash

sudo LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/apache2

sudo apt-get update
sudo apt-get install -y apache2
```

Create `HOST_FOLDER/html/index.html`:

```
<html>
<head>
	<title>Amazing Test Project</title>
</head>
<body>
	<p>How cool is this?</p>
</body>
</html>
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

### <a id="step_03"></a> 3. Install PHP 8.0

`Vagrantfile`:

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# Variables
PROJECT_NAME        = "Amazing Test Project"
MEMORY              = 4096
CPUS                = 1
IP                  = "192.168.88.188"
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"
PHP_VERSION         = "8.0"

Vagrant.configure("2") do |config|

	config.vm.box = "hashicorp/bionic64"

	config.vm.provider "virtualbox" do |v|
		v.name = PROJECT_NAME
		v.memory = MEMORY
		v.cpus = CPUS
	end

	config.vm.network "private_network", ip: IP

	# Set a synced folder
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Execute shell script(s)
	config.vm.provision :shell, path: "provision/components/apache.sh"
	config.vm.provision :shell, path: "provision/components/php.sh", :args => [PHP_VERSION]

end
```

Create `provision/components/php.sh`:

```
#!/bin/bash

apt-get install software-properties-common
LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php
apt-get update
apt-get install -y php$1 php$1-mysql

sed -i 's/max_execution_time = .*/max_execution_time = 60/' /etc/php/$1/apache2/php.ini
sed -i 's/post_max_size = .*/post_max_size = 64M/' /etc/php/$1/apache2/php.ini
sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/' /etc/php/$1/apache2/php.ini
sed -i 's/memory_limit = .*/memory_limit = 512M/' /etc/php/$1/apache2/php.ini
sed -i 's/display_errors = .*/display_errors = on/' /etc/php/$1/apache2/php.ini
sed -i 's/display_startup_errors = .*/display_startup_errors = on/' /etc/php/$1/apache2/php.ini

service apache2 restart
```

Create `HOST_FOLDER/html/phpinfo.php`:

```
<?php
phpinfo();
```

Run:

```
vagrant provision
```

* When finished, [http://192.168.88.188/phpinfo.php](http://192.168.88.188/phpinfo.php), which should successfully display the PHP info page.

--

### <a id="step_04"></a> 4. Install MySQL

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
	config.vm.provision :shell, path: "provision/components/prevision.sh"
	config.vm.provision :shell, path: "provision/components/apache.sh"
	config.vm.provision :shell, path: "provision/components/php.sh"
	config.vm.provision :shell, path: "provision/components/mysql.sh"
end
```

Create `provision/components/mysql.sh`:

```
#!/bin/bash

DBHOST=localhost
RTPASSWD=password
DBNAME=mydb
DBUSER=myuser
DBPASSWD=password

# Install MySQL
apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $RTPASSWD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $RTPASSWD"

apt-get -y install mysql-server

# Create the database and grant privileges
CMD="mysql -uroot -p$DBPASSWD -e"

$CMD "CREATE DATABASE IF NOT EXISTS $DBNAME"
$CMD "GRANT ALL PRIVILEGES ON $DBNAME.* TO '$DBUSER'@'%' IDENTIFIED BY '$DBPASSWD';"
$CMD "FLUSH PRIVILEGES;"

# Allow remote access to the database
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart
```

Customise `RTPASSWD`, `DBNAME`, `DBUSER`, & `DBPASSWD` to suit yourself.

Run:

```
vagrant provision
```

Create `synced/html/db.php`:

```
<?php
$conn = mysqli_connect("localhost", "myuser", "password", "mydb");

if (!$conn) {
	die("Error: " . mysqli_connect_error());
}

echo "Connected!";
```

Peplace `localhost`, `myuser`, `password`, `mydb` with the values used in `db.php`.

* Visit [http://192.168.88.188/db.php](http://192.168.88.188/db.php) and if all went well you should be seeing the "*Connected!*" message.















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

