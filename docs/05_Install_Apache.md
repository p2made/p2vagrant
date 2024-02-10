# 05 Install Apache (with SSL 🙃)

Updated: 2024-02-02

--

In addition to using `fish`, I start putting anything that's used more than once into an include file, `common_functions.fish`. Which brings us to...

### Create `provision/scripts/common_functions.fish `

```
#!/bin/fish

# common_functions.fish
# Updated: 2024-02-08

# Script constants...
set TODAYS_DATE         (date "+%Y-%m-%d")
set VM_FOLDER           /var/www
set SHARED_HTML         $VM_FOLDER/html
set PROVISION_FOLDER    $VM_FOLDER/provision
set PROVISION_DATA      $VM_FOLDER/provision/data
set PROVISION_HTML      $VM_FOLDER/provision/html
set PROVISION_LOGS      $VM_FOLDER/provision/logs
set PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
set PROVISION_SSL       $VM_FOLDER/provision/ssl
set PROVISION_TEMPLATES $VM_FOLDER/provision/templates
set PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/      Update & Install Packages      /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to update package with error handling
# Usage: update_package_lists
function update_package_lists
	echo "🔄 Updating package lists 🔄"

	if not apt-get -q update > /dev/null 2>&1
		handle_error "Failed to update package lists"
	end

	announce_success "Package lists updated successfully."
end

# Function to install packages with error handling
# Usage: install_packages $package_list
function install_packages
	echo "🔄 Installing Packages 🔄"

	for package in $argv
		set cleaned (eval echo $package)
		if not apt-get -qy install $cleaned
			handle_error "Failed to install packages"
		end
	end

	announce_success "Packages installed successfully!"
end

# Function to update package lists the install packages with error handling
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list
function update_and_install_packages
	update_package_lists
	install_packages $argv
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/           Configure Sites           /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

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
# Usage: write_vhosts_file $domain $underscore_domain $template_filename $vhosts_filename $ssl_base_filename
function write_vhosts_file
	set domain            $argv[1]
	set underscore_domain $argv[2]
	set template_filename $argv[3]
	set vhosts_filename   $argv[4]
	set ssl_base_filename $argv[5]

	# Check if the template file exists
	if not test -f $PROVISION_TEMPLATES/$template_filename
		handle_error "Template file $template_filename.conf not found in $PROVISION_TEMPLATES"
	end

	# Use sed to replace placeholders in the template and save it to the new file
	sed \
		-e "s|{{DOMAIN}}|$domain|g" \
		-e "s|{{UNDERSCORE_DOMAIN}}|$underscore_domain|g" \
		-e "s|{{SSL_BASE_FILENAME}}|$ssl_base_filename|g" \
		-e "s|{{TODAYS_DATE}}|$TODAYS_DATE|g" \
		$PROVISION_TEMPLATES/$template_filename > $PROVISION_VHOSTS/$vhosts_filename

	# Output progress message
	announce_success "Vhosts file for $domain created at $PROVISION_VHOSTS/$vhosts_filename"
end

# Function to generate SSL files
# Usage: generate_ssl_files $domain $ssl_base_filename
function generate_ssl_files
	set domain   $argv[1]
	set ssl_key  $PROVISION_SSL/$argv[2].key
	set ssl_cert $PROVISION_SSL/$argv[2].cert

	# Check if SSL folder exists
	if not test -d $PROVISION_SSL
		handle_error "SSL folder $PROVISION_SSL not found"
	end

	# Generate SSL key
	echo "🔄 Generating SSL key 🔄"
	if not openssl genrsa \
		-out $ssl_key \
		2048

		handle_error "Failed to generate SSL key for $domain"
	end

	# Output progress message
	announce_success "SSL key for $domain generated at $ssl_key."

	# Generate self-signed SSL certificate
	echo "🔄 Generating self-signed SSL certificate 🔄"
	if not openssl req -nodes -x509 \
		-key $ssl_key \
		-out $ssl_cert \
		-days 3650 \
		-subj "/CN=$domain"

		handle_error "Failed to generate self-signed SSL certificate for $domain"
	end

	# Output progress message
	announce_success "Self-signed SSL certificate for $domain generated at $ssl_cert."

	announce_success "SSL files for $domain generated successfully!"

	# Display information about the generated certificate
	openssl x509 -noout -text -in $ssl_cert
end

# Function to configure a website with everything done so far
# Usage: configure_website $site_info
function configure_website
	set domain            $argv[1]
	set site_folder       $VM_FOLDER/$argv[2]
	set vhosts_filename   $argv[3]
	set ssl_base_filename $argv[4]

	# Put `conf` & SSL files into place
	sudo cp -f $PROVISION_VHOSTS/$vhosts_filename  /etc/apache2/sites-available/
	sudo cp -f $PROVISION_SSL/$ssl_base_filename.* /etc/apache2/sites-available/

	# Create site root if it doesn't already exist
	mkdir -p $site_folder

	# Copy files only if they do not exist
	set files_to_copy "index.html" "index.php" "phpinfo.php" "db.php"
	for file in $files_to_copy
		cp -u $PROVISION_HTML/$file $site_folder/
	end

	# Enable site
	sudo a2ensite $vhosts_filename

	# Output progress message
	echo "Website configured for $domain"
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/          Utility Functions          /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function for error handling
# Use without closing punctuation on the message.
# Usage: handle_error "Error message"
function handle_error
	echo "⚠️ Error: $argv 💥"
	echo "Run `vagrant halt` then restore the last snapshot before trying again."
	exit 1
end

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success
	set icon "✅"

	if test -n "$argv[2]" && ["$argv[2]" -eq 1]
		set icon "👍"
	end

	echo "$icon $argv[1]"
end

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job
	echo "👍 $1"
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/       Header & Footer Banners       /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/                                     /%/ -- -- /%/ -- -- #
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Banner flags
set ua "🇺🇦"
set btbu " 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇺🇦"
set btb $btbu$btbu$btbu$btbu$btbu

# Function to write shalom peace salam banner
# Usage: peace_banner i - where i is 1 to 4
function peace_banner
	switch $argv[1]
		case 1 # Binary
			echo "$ua    🕊️  01110011 01101000 01100001 01101100 01101111 01101101 🕊️"
			echo "$ua    🕊️  01110000 01100101 01100001 01100011 01100101          🕊️"
			echo "$ua    🕊️  01110011 01100001 01101100 01100001 01101101          🕊️"
		case 2 # Hexadecimal
			echo "$ua    🕊️  73 68 61 6C 6F 6D 🕊️"
			echo "$ua    🕊️  70 65 61 63 65    🕊️"
			echo "$ua    🕊️  73 61 6C 61 6D    🕊️"
		case 3 # Octal
			echo "$ua    🕊️  163 150 141 154 157 155 🕊️"
			echo "$ua    🕊️  160 145 141 143 145     🕊️"
			echo "$ua    🕊️  163 141 154 141 155     🕊️"
		case 4 # Morse Code
			echo "$ua    🕊️  ... .... .- .-.. --- -- 🕊️"
			echo "$ua    🕊️     .--. . .- -.-. .     🕊️"
			echo "$ua    🕊️     ... .- .-.. .- --    🕊️"
	end
end

# Function to write header banner
# Usage: header_banner $active_title $script_name $updated_date
function header_banner
	echo "$ua$btb"
	echo "$ua"
	echo "$ua                        ___"
	echo "$ua                  _____|_  )                   _           _"
	echo "$ua         /\      |  __ \/ /                   (_)         | |"
	echo "$ua        /  \     | |__)/___|   _ __  _ __ ___  _  ___  ___| |_"
	echo "$ua       / /\ \    |  ___/      | '_ \| '__/ _ \| |/ _ \/ __| __|"
	echo "$ua      / ____ \   | |          | |_) | | | (_) | |  __/ (__| |_"
	echo "$ua     /_/    \_\  |_|          | .__/|_|  \___/| |\___|\___|\__|"
	echo "$ua                              | |            _/ |"
	echo "$ua                              |_|           |__/"
	echo "$ua"
	echo "$ua      🚀 $argv[1] 🚀"
	echo "$ua      📅     on $TODAYS_DATE"
	echo "$ua"
	echo "$ua      📜 Script Name:  $argv[2]"
	echo "$ua      📅 Last Updated: $argv[3]"
	echo "$ua"
	echo "$ua$btb"
	echo ""
end

# Function to write footer banner
# Usage: footer_banner $job_complete
function footer_banner
	echo ""
	echo "$ua$btb"
	echo "$ua"
	echo "$ua      🏆 $argv[1] ‼️"
	echo "$ua"
	peace_banner (math (random) % 4 + 1)
	echo "$ua"
	echo "$ua$btb"
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

```

I had gone some way with this approach before updating these docs, so `common_functions.fish` comes as it is well beyond this step. A consequence of using `common_functions.fish ` is right up the top, `set -U VM_FOLDER /var/www`. It turned that hard coding that made setting all the values based on `VM_FOLDER` as simple as you see there. Doing it by passing an argument from the `Vagrantfile` is sufficiently more complicated to be worth the one item of data duplication. In return I've been able to replace a multitude of strings with those constants.

### Create `provision/scripts/install_apache.fish`

```
#!/bin/fish

# 05 Install Apache (with SSL)

set script_name     "install_apache.fish"
set updated_date    "2024-02-07"

set active_title    "Installing Apache (with SSL 🙃)"
set job_complete    "Apache Installed (with SSL 🙃)"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - VM_IP = "192.168.22.42"

# Script variables...
set VM_IP $argv[1]

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

set -x DEBIAN_FRONTEND noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Add repository for ondrej/apache2
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

announce_success "Apache packages installed successfully!"

set domain            $VM_IP
set ssl_base_filename "$VM_IP"_"$TODAYS_DATE"

generate_ssl_files $domain $ssl_base_filename

# Copy web server files into place
yes | cp $PROVISION_VHOSTS/local.conf /etc/apache2/sites-available/
yes | cp $PROVISION_SSL/* /etc/apache2/sites-available/
yes | cp $PROVISION_HTML/index.htm $SHARED_HTML/

# Check if index.html exists in the html folder
if not test -e $SHARED_HTML/index.html
	cp $PROVISION_HTML/index.html $SHARED_HTML/
end

# Set permissions on web server files
chmod -R 755 $SHARED_HTML/*
chmod 600 /etc/apache2/sites-available/$ssl_base_filename.key

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

# Restart Apache to apply changes
systemctl restart apache2

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete
```

By moving common logic to `common_functions.fish`, I've been able to make this script, & all the ones that follow, a lot more concise.


### Create `provision/html/index.htm`

```
<html>
<head>
	<title>Shaka Bom!</title>
</head>
<body>
	<h1>Shaka Bom!</h1>
	<p>How cool is this?</p>
</body>
</html>
```

The page is a simple `index.html` located within your VM in the `/var/www/html` directory, the so-called document root. This document root is the directory that's available from the outside to your server.

### Create `provision/vhosts/local.conf`

```
<VirtualHost *:80>
	ServerAdmin admin@example.com
	DocumentRoot /var/www/html
    DirectoryIndex index.htm index.html index.php

	<Directory /var/www/html>
		# Allow .htaccess rewrite rules
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	ErrorLog "/var/log/apache2/localhost-error_log"
	CustomLog "/var/log/apache2/localhost-access_log" common
</VirtualHost>
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 05 Install Apache (with SSL)
# Generated: 2024-02-11

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

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
	config.vm.provision :shell, path: "provision/scripts/install_apache.fish", args: [VM_IP]

end
```

Or run..

```
./provision/scripts/vg.sh 5
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

### Visit

* [http://192.168.22.42/](http://192.168.22.42/)

You should see a minimal page that I put there. For the Apache default page of your VM visit...

* [http://192.168.22.42/index.html](http://192.168.22.42/index.html)


### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 05 Install Apache (with SSL) -->
| [04 Upgrade VM (revisited)](./04_Upgrade_VM.md)
| [**Back to Steps**](../README.md)
| [06 Install PHP (with Composer)](./06_Install_PHP.md)
|
