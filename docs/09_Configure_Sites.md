# 09 Configure Sites

Updated: 2024-02-04

--

### ### Create `provision/data/sites_data`

```
# Sites data
# one site per space separated line
# domain template_num [vhosts_prefix]
example.test 1 000
# subdomains
#subdomain1.example.test 0
#subdomain2.example.test 0
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
set updated_date    "2024-02-03"

set active_title    "Configuring Websites"
set job_complete    "Websites Configured"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# NONE!"

# File path for site data
set site_data_file "/var/www/provision/data/sites_data"

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to setup important site variables
# We can't return a value, so we put them in a global variable
# that we will quickly use & then erase.
# Usage: setup_site_variables $one_site
function setup_site_variables
	# Use the passed string $one_site to set a temporary global...
	# $site_info_temp[1-6], where...
	# $site_info_temp[1] is the domain
	# $site_info_temp[2] is the reverse domain
	# $site_info_temp[3] is the underscore domain
	# $site_info_temp[4] is the template filename
	# $site_info_temp[5] is the vhosts filename
	# $site_info_temp[6] is the SSL filename

	set split_string (string split ' ' $argv)

	set -g site_info_temp[1] $split_string[1]                          # 1 domain name

	set parts (string split '.' $split_string[1])

	for part in $parts
		set -p reversed $part
	end

	set -g site_info_temp[2] (string join "." $reversed)               # 2 reverse domain
	set -g site_info_temp[3] (string join "_" $reversed)               # 3 underscore domain

	set -g site_info_temp[4] $split_string[2].conf                     # 4 template filename

	if set -q split_string[3]
		set -g site_info_temp[5] $split_string[3]_
	else
		set -g site_info_temp[5] ""
	end

	set -g site_info_temp[5] $site_info_temp[5]$site_info_temp[3].conf # 5 vhosts filename
	set -g site_info_temp[6] $site_info_temp[3]_$TODAYS_DATE           # 6 SSL base filename
end

# Function to write the vhosts file from a template
# Usage: write_vhosts_file $site_info
function write_vhosts_file
	# Check if the template file exists
	if not test -f $PROVISION_TEMPLATES/$argv[4]
		handle_error "Template file $template_filename.conf not found in $PROVISION_TEMPLATES"
	end

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		-e "s|{{DOMAIN}}|$argv[1]|g" \
		-e "s|{{UNDERSCORE_DOMAIN}}|$argv[3]|g" \
		-e "s|{{SSL_FILENAME}}|$argv[6]|g" \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
		$PROVISION_TEMPLATES/$argv[4] > $PROVISION_VHOSTS/$argv[5]

	# Output progress message
	echo "Vhosts file for $argv[1] created at $PROVISION_VHOSTS/$argv[5]"
end

# Function to generate SSL files
# Usage: generate_ssl_files $site_info
function generate_ssl_files
	# Check if SSL folder exists
	if not test -d $PROVISION_SSL
		handle_error "SSL folder $PROVISION_SSL not found"
	end

	# Generate SSL key
	if not openssl genrsa -out $PROVISION_SSL/$argv[6].key 2048
		handle_error "Failed to generate SSL key for $argv[1]"
	end

	# Output progress message
	echo "SSL key for $argv[1] generated at $PROVISION_SSL/$argv[6].key"

	# Generate self-signed SSL certificate
	if not openssl req -new -x509 \
		-key $PROVISION_SSL/$argv[6].key \
		-out $PROVISION_SSL/$argv[6].cert \
		-days 3650 \
		-subj /CN=$argv[1]
		handle_error "Failed to generate SSL certificate for $argv[1]"
	end
	# Output progress message
	echo "SSL certificate for $argv[1] generated at $PROVISION_SSL/$argv[6].cert"
end

# Function to configure a website with everything done so far
# Usage: configure_website $site_info
function configure_website
	# Put `conf` & SSL files into place
	sudo cp -f $PROVISION_VHOSTS/$argv[5] /etc/apache2/sites-available/
	sudo cp -f $PROVISION_SSL/$argv[6].* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p $VM_FOLDER/$argv[3]

	# Copy files only if they do not exist
	set files_to_copy "index.html" "index.php" "phpinfo.php" "db.php"
	for file in $files_to_copy
		cp -u $PROVISION_HTML/$file $VM_FOLDER/$argv[3]/
	end

	# Enable site
	sudo a2ensite $argv[5]

	# Output progress message
	echo "Website configured for $argv[1]"
end

for one_site in (cat $site_data_file | grep -v '^#')
	# First get thy data in order, young coder
	setup_site_variables $one_site

	# We have the data all as we want it, but in a global variable
	# Put it in a local variable, & erase the global variable
	set site_info $site_info_temp
	set -e site_info_temp

	# Output progress message
	echo "Variables for $site_info[1]..."
	echo "\$site_info[1] - domain            = $site_info[1]"
	echo "\$site_info[2] - reverse domain    = $site_info[2]"
	echo "\$site_info[3] - underscore domain = $site_info[3]"
	echo "\$site_info[4] - template filename = $site_info[4]"
	echo "\$site_info[5] - vhosts filename   = $site_info[5]"
	echo "\$site_info[6] - SSL base filename = $site_info[6]"

	# Now all the data for a site is in `site_info`
	# Within functions, replace 'site_info' with 'argv'

	# Now go configure some web sites
	write_vhosts_file  $site_info
	generate_ssl_files $site_info
	configure_website  $site_info
end

# Restart Apache after all configurations
echo "Restarting apache to enable new websites."
sudo service apache2 restart
echo "Websites setup complete."

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 09 Configure Sites
# Updated: 2024-02-07

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
VM_IP               = "192.168.22.42"      # 22 = titanium, 42 = Douglas Adams's number

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

# Software Versions
PHP_VERSION         = "8.3"
MYSQL_VERSION       = "8.1"

# Database Variables
ROOT_PASSWORD       = "RootPassw0rd"
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
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.fish", run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh"
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
#	config.vm.provision :shell, path: "provision/scripts/install_apache.fish"
#	config.vm.provision :shell, path: "provision/scripts/install_php.fish", args: [PHP_VERSION]
#	config.vm.provision :shell, path: "provision/scripts/install_mysql.fish", args: [MYSQL_VERSION, PHP_VERSION, ROOT_PASSWORD, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_NAME_TEST]
	config.vm.provision :shell, path: "provision/scripts/install_apache.fish", args: [VM_IP]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_09 ./Vagrantfile
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

### Edit the `hosts` file of you Mac

Open the file `/etc/hosts` in your preferred text editor. I use [BBEdit](https://www.barebones.com/products/bbedit/), with which I can open the file from Terminal with `BBEdit /etc/hosts`, or by navigating to it in the open file dialog of BBEdit. You will need to confirm for editing the file, then authenticate as an admin user to save it.

Add this line...

```
192.168.22.42 test *.test *.*.test
```

If you've used a different IP address, &/or different TLD, substitute accordingly. If you use more than one TLD, you will need one line like this for each. The `*.` parts should match the depth of subdomains used. So if you have `subdomain2. subdomain1.example.test` you will need to add `*.*.*.test`.


**DO NOT** edit anything already in the `hosts` file unless you are supremely confident of knowing what you are doing. I separate the original from my additions with this comment...

```
# original above, additions below
```

There is a copy of the Ubuntu guest `hosts` file, with these edits made, in `/provision/etc`. **DO NOT** copy that file to `/etc/hosts` on yout Mac. Those edits are only necessary on the VM if you want to access the websites directly on the VM.

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

| [08 Upgrade VM (revisited)](./08_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [10 Page Title](./10_Page_Title.md)
|
