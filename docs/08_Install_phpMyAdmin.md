# 08 Install phpMyAdmin

--

### Create `provision/scripts/install_phpmyadmin.sh`:

```
#!/bin/sh

# 08 Install phpMyAdmin

echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "#####                                                       #####"
echo "#####       Installing phpMyAdmin                           #####"
echo "#####                                                       #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo "##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####"
echo ""

export DEBIAN_FRONTEND=noninteractive

# PMA_VERSION         = "5.2.1"               | $1
# DB_PASSWORD         = "PM4Passw0rd"         | $2
# REMOTE_FOLDER       = "/var/www"            | $3

LC_ALL=C.UTF-8 apt-add-repository -yu ppa:phpmyadmin/ppa

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get -qy install phpmyadmin

rm -rf /usr/share/phpmyadmin

cp -r $3/provision/html/phpMyAdmin $3/html/phpMyAdmin

sudo chmod -R 755 $3/html/phpmyadmin

sudo phpenmod mbstring
service apache2 restart
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 08 Install phpMyAdmin

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane"
#TIMEZONE            = "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.2"
MYSQL_VERSION       = "8.1"
PMA_VERSION         = "5.2.1"

# Database Variables
RT_PASSWORD         = "Passw0rd0ne"
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rd"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: 'always'

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"
	config.vm.provision :shell, path: "provision/scripts/install_php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/install_mysql.sh", :args => [MYSQL_VERSION, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/install_phpmyadmin.sh", :args => [PMA_VERSION, DB_PASSWORD, REMOTE_FOLDER]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_08 ./Vagrantfile
```

### Provision the VM

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
```

### Visit your phpMyAdmin

* [http://192.168.42.100/phpmyadmin/](http://192.168.42.100/phpmyadmin/)
* Log in with, user `DB_USERNAME` & password `DB_PASSWORD`.

#### Accessing the Database from Outside the VM

To access your database with a GUI you'll need to use a SSH connection. How to set this up depends on the software you're using, but in general these are the things you'll need to configure:

Item        | Value
----------- | -----
`Host`      | 127.0.0.1
`Username`  | `DB_USERNAME` from `Vagrantfile`
`Password`  | `DB_PASSWORD` from `Vagrantfile`
`SSH Host`  | 127.0.0.1
`SSH User`  | vagrant
`SSH Key`   | Can be found in this location in your project directory: /.vagrant/machines/default/virtualbox/private_key
`SSH Port`  | 2222

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [07 Install MySQL](./07_Install_MySQL.md)
| [**Back to Steps**](../README.md)
| [09 Install Yarn](./09_Install_Yarn.md)
|
