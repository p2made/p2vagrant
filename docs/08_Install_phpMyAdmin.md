# 08 Install phpMyAdmin

--

### section_title

some_text

```
some_code
```

### section_title

some_text

```
some_code
```

### Update `Vagrantfile`

```
vagrantfile
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
* Log in with, user `phpmyadmin` & password given during the install.

#### Accessing the Database from Outside the VM

To access your database with a GUI you'll need to use a SSH connection. How to set this up depends on the software you're using, but in general these are the things you'll need to configure:

Item | Value
---- | -----
`Host` | 127.0.0.1
`Username` | phpmyadmin
`Password` | password given during the install
`SSH Host` | 127.0.0.1
`SSH User` | vagrant
`SSH Key`  | Can be found in this location in your project directory: /.vagrant/machines/default/virtualbox/private_key
`SSH Port` | 2222

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [07 Install MySQL](./07_Install_MySQL.md)
| [**Back to Steps**](../README.md)
| [09 Page Title](./09_Page_Title.md)
|







# 05 Install phpMyAdmin

--

Installing phpMyAdmin using a provisioning script is failing for me, so I'm doing it manually. `Vagrantfile_05` & `provision/scripts/phpmyadmin.sh` exist in the project for preservation, but are not currently used. Lines in Vagrantfiles that relate to installing phpMyAdmin are commented out.

#### First SSH into the VM…

```
vagrant ssh
```

#### Now run…

```
LC_ALL=C.UTF-8 sudo apt-add-repository -yu ppa:phpmyadmin/ppa
sudo apt update
sudo apt -qy install phpmyadmin
```

During the install, accept the default options & enter a password of your choosing.

#### Now run…

```
sudo rm -rf /usr/share/phpmyadmin

cd /tmp
wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip
unzip phpMyAdmin-5.2.1-all-languages.zip
rm phpMyAdmin-5.2.1-all-languages.zip
sudo mv phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin

sudo chmod -R 755 /var/www/html/phpmyadmin
```

Permissions are fixed in the `chmod` step, so ignore the permissions failures in the `mv` step.

#### Finally run…

```
sudo phpenmod mbstring
sudo systemctl restart apache2
```






# 05 Install phpMyAdmin

--

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 05 Install phpMyAdmin

# Machine Variables
MEMORY              = 4096
CPUS                = 1
VM_IP               = "192.168.42.100"
SSH_PASSWORD        = 'vagrant'

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
PMA_PASSWORD        = "PM4Passw0rd"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory = MEMORY
		v.cpus   = CPUS
		v.gui    = true
	end

	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/upgrade.sh"
	config.vm.provision :shell, path: "provision/scripts/utilities.sh"
	config.vm.provision :shell, path: "provision/scripts/install_apache.sh"
	config.vm.provision :shell, path: "provision/scripts/php.sh", :args => [PHP_VERSION]
	config.vm.provision :shell, path: "provision/scripts/mysql.sh", :args => [MYSQL_VERSION, RT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/phpmyadmin.sh", :args => [PHPMYADMIN_VERSION, PMA_PASSWORD, REMOTE_FOLDER]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_05 ./Vagrantfile
```

### Create `provision/scripts/phpmyadmin.sh`:

```
#!/bin/sh

# 05 Install phpMyAdmin

#PMA_VERSION         = $1 = "5.2.1"
#PMA_PASSWORD        = $2 = "PM4Passw0rd"
#REMOTE_FOLDER       = $3 = "/var/www"

apt-get update

debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $2"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

apt-get -qy install phpmyadmin

#rm -rf /usr/share/phpmyadmin

#cd /tmp
#wget https://files.phpmyadmin.net/phpMyAdmin/$1/phpMyAdmin-$1-all-languages.zip
#unzip phpMyAdmin-$1-all-languages.zip
#rm phpMyAdmin-$1-all-languages.zip
sudo mv /usr/share/phpmyadmin $3/html/phpmyadmin
#sudo mv phpMyAdmin-$1-all-languages $3/html/phpmyadmin

sudo chmod -R 755 $3/html/phpmyadmin

phpenmod mbstring

systemctl restart apache2
```

#### Run:

```
vagrant provision
```

or

```
vagrant reload --provision
```

* Visit [http://192.168.42.100/phpmyadmin/](http://192.168.42.100/phpmyadmin/), log in with user/password.

#### Accessing the Database from Outside the VM

To access your database with a GUI you'll need to use a SSH connection. How to set this up depends on the software you're using, but in general these are the things you'll need to configure:

Item | Value
---- | -----
`Host` | 127.0.0.1
`Username` | myuser (which we've defined in mysql.sh)
`Password` | password (which we've also defined in mysql.sh)
`SSH Host` | 127.0.0.1
`SSH User` | vagrant
`SSH Key` | Can be found in this location in your project directory: /.vagrant/machines/default/virtualbox/private_key
`SSH Port` | 2222

