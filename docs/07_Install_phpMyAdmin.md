# 08 Install phpMyAdmin

--

### Create `provision/scripts/07_install_phpmyadmin.fish`

```
#!/bin/fish

# 06 Install phpMyAdmin

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing phpMyAdmin 🚀"
echo "🇺🇿    📜 Script Name:  07_install_phpmyadmin.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-28"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Arguments...
# 1 - REMOTE_FOLDER     = "/var/www"

set REMOTE_FOLDER $argv[1]

set PACKAGE_LIST \
	phpmyadmin

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Add repository for phpMyAdmin
LC_ALL=C.UTF-8 sudo apt-add-repository -yu ppa:phpmyadmin/ppa

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

# Remove the default phpMyAdmin directory
rm -rf /usr/share/phpmyadmin

# Copy phpMyAdmin to the specified folder
cp -R $REMOTE_FOLDER/provision/html/phpmyadmin $REMOTE_FOLDER/html/phpmyadmin

# Set permissions
chmod -R 755 $REMOTE_FOLDER/html/phpmyadmin

# Enable mbstring
phpenmod mbstring

# Restart Apache to apply changes
systemctl restart apache2

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 phpMyAdmin Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 06 Install MySQL
# Updated: 2024-01-28

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.3"
MYSQL_VERSION       = "8.1"
PMA_VERSION         = "5.2.1"

# Database Variables
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rd"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"
PMA_USERNAME        = "pmauser"
PMA_PASSWORD        = "PM4Passw0rd"

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

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/02_upgrade_vm.sh"
#	config.vm.provision :shell, path: "provision/scripts/03_install_utilities.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/04_install_apache.fish"
#	config.vm.provision :shell, path: "provision/scripts/05_install_php.fish", args: [PHP_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/06_install_mysql.fish", args: [MYSQL_VERSION, PHP_VERSION, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/07_install_phpmyadmin.fish"

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_07 ./Vagrantfile
```

### Provision the VM

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
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

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [08 Install MySQL](./08_Install_MySQL.md)
| [**Back to Steps**](../README.md)
| [10 Install Yarn](./10_Install_Yarn.md)
|
