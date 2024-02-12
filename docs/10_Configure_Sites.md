# 10 Configure Sites

Updated: 2024-02-13

--

### ### Create `provision/data/sites_data`

```
# Sites data
# one site per space separated line
# domain template_num [vhosts_prefix]
example.test 1 000
# subdomains
subdomain1.example.test 0
subdomain2.example.test 0
```

Using a data file means that more sites can be added simply by updating the data file & running this provisioning script again. **Do not** do this to change sites already created.

The data file is a simple format. There is one space delimited line for each site. Lines beginning with `#` are treated as comments & ignored. The fields are...

1. `domain` - If you're reading this, you know what a domain is. All the domains in this project are on the `.test` TLD.
2. `template_number` - The numeric part of a `vhosts` template filename, `n.conf`, where `n` is this value. Currently there are `0.conf` for a basic `vhosts` file, &  `1.conf` for a more advanced one.
3. `vhosts_prefix` - An optional field to prefix the `vhosts` filename. Useful for setting the order in which Apache loads `vhosts` files. Most commonly a 3 digit string, `000`.

### Create `provision/scripts/configure_sites.fish`

```
#!/bin/fish

# 09 Configure Sites

set script_name     "configure_sites.fish"
set updated_date    "2024-02-12"

set active_title    "Configuring Websites"
set job_complete    "Websites Configured"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Arguments...
# NONE!"

# Script variables...
# NONE!"

# File path for site data
set site_data_file "/var/www/provision/data/sites_data"

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to loop through sites data & configure individual websites
# Usage: onfigure_websites
function onfigure_websites
	for one_site in (cat $site_data_file | grep -v '^#')
		# First get thy data in order, young coder
		setup_site_variables $one_site

		# We have the data all as we want it, but in a global variable
		# Put it in local variables, & erase the global variable
		set domain            $site_info_temp[1]
		set reverse_domain    $site_info_temp[2]
		set underscore_domain $site_info_temp[3]
		set template_filename $site_info_temp[4]
		set vhosts_filename   $site_info_temp[5]
		set ssl_base_filename $site_info_temp[6]

		set -e site_info_temp

		# Output progress message
		echo "Data for $one_site..."
		echo "\$domain            $domain"
		echo "\$reverse_domain    $reverse_domain"
		echo "\$underscore_domain $underscore_domain"
		echo "\$template_filename $template_filename"
		echo "\$vhosts_filename   $vhosts_filename"
		echo "\$ssl_base_filename $ssl_base_filename"

		# Now go configure some web sites
		write_vhosts_file \
			$domain \
			$underscore_domain \
			$template_filename \
			$vhosts_filename \
			$ssl_base_filename
		generate_ssl_files \
			$domain \
			$ssl_base_filename
		configure_website \
			$domain \
			$underscore_domain \
			$vhosts_filename \
			$ssl_base_filename

		# $domain $reverse_domain $underscore_domain $template_filename $vhosts_filename $ssl_base_filename
	end

	# Restart Apache after all configurations
	echo "Restarting apache to enable new websites."
	sudo service apache2 restart
	announce_success "Websites setup complete."
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function advance_vm
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	set -x DEBIAN_FRONTEND noninteractive

	onfigure_websites

	# Footer banner
	footer_banner "$job_complete"
end

advance_vm
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 10 Configure Sites
# Generated: 2024-02-13

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
SWIFT_VERSION       = "5.9.2"
PHP_VERSION         = "8.3"
MYSQL_VERSION       = "8.3"

# Database Variables
ROOT_PASSWORD       = "RootPassw0rd"
DB_USERNAME         = "fredspotty"
DB_PASSWORD         = "Passw0rd"
DB_NAME             = "example_db"
DB_NAME_TEST        = "example_db_test"

Vagrant.configure("2") do |config|

	config.vm.box = "bento/ubuntu-20.04-arm64"

	config.vm.provider "vmware_desktop" do |v|
		v.memory    = MEMORY
		v.cpus      = CPUS
		v.gui       = true
	end

	# Configure network...
	config.vm.network "private_network", ip: VM_IP

	# Set a synced folder...
	config.vm.synced_folder HOST_FOLDER, REMOTE_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", args: [VM_HOSTNAME], run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh"
#	config.vm.provision :shell, path: "provision/scripts/install_swift.fish", args: [SWIFT_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_apache.fish", args: [VM_HOSTNAME, VM_IP]
#	config.vm.provision :shell, path: "provision/scripts/install_php.fish", args: [PHP_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_mysql.fish", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/configure_sites.fish"

end
```

Or run...

```
./vg 10
```

### Provision the VM...

If the VM is **not** running

```
vagrant up --provision
```

If the VM is running

```
vagrant reload --provision
```

### Import SSL certificates to System Keychain

Just the same PITA process as before.

### Edit the `hosts` file of your Mac

Edit `/etc/hosts` again to add these lines...

```
192.168.22.42   example.test
192.168.22.42   subdomain1.example.test
192.168.22.42   subdomain2.example.test
```

If you've used a different IP address, &/or different domains, substitute accordingly. If you use more than one TLD, you will need one line like this for each. The `*.` parts should match the depth of subdomains used. So if you have `subdomain2. subdomain1.example.test` you will need to add `*.*.*.test`.

**🚨 DO NOT** edit anything already in the `hosts` file unless you are supremely confident of knowing what you are doing. I separate the original from my additions with this comment...

```
# original above, additions below
```

There is a copy of the Ubuntu guest `hosts` file, with these edits made, in `/provision/etc`. **🚨 DO NOT** copy that file to `/etc/hosts` on yout Mac. Those edits are only necessary on the VM if you want to access the websites directly on the VM.

### Visit

* [example.test/index.php](http://example.test/index.php)
* [example.test/phpinfo.php](http://example.test/phpinfo.php)
* [example.test/db.php](http://example.test/db.php)
* [example.test/index.html](http://example.test/index.html)
* [subdomain1.example.test/index.php](http://subdomain1.example.test/index.php)
* [subdomain1.example.test/phpinfo.php](http://subdomain1.example.test/phpinfo.php)
* [subdomain1.example.test/db.php](http://subdomain1.example.test/db.php)
* [subdomain1.example.test/index.html](http://subdomain1.example.test/index.html)
* [subdomain2.example.test/index.php](http://subdomain2.example.test/index.php)
* [subdomain2.example.test/phpinfo.php](http://subdomain2.example.test/phpinfo.php)
* [subdomain2.example.test/db.php](http://subdomain2.example.test/db.php)
* [subdomain2.example.test/index.html](http://subdomain2.example.test/index.html)

Or for the `https` versions...

* [example.test/index.php](https://example.test/index.php)
* [example.test/phpinfo.php](https://example.test/phpinfo.php)
* [example.test/db.php](https://example.test/db.php)
* [example.test/index.html](https://example.test/index.html)
* [subdomain1.example.test/index.php](https://subdomain1.example.test/index.php)
* [subdomain1.example.test/phpinfo.php](https://subdomain1.example.test/phpinfo.php)
* [subdomain1.example.test/db.php](https://subdomain1.example.test/db.php)
* [subdomain1.example.test/index.html](https://subdomain1.example.test/index.html)
* [subdomain2.example.test/index.php](https://subdomain2.example.test/index.php)
* [subdomain2.example.test/phpinfo.php](https://subdomain2.example.test/phpinfo.php)
* [subdomain2.example.test/db.php](https://subdomain2.example.test/db.php)
* [subdomain2.example.test/index.html](https://subdomain2.example.test/index.html)

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 10 Configure Sites -->
| [09 Install phpMyAdmin](./09_Install_phpMyAdmin.md)
| [**Back to Steps**](../README.md)
|
