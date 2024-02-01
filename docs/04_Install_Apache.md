# 04 Install Apache (with SSL 🙃)

**Updated:** 2024-01-28

--

### Create `provision/scripts/04_install_apache.fish`

```
#!/bin/fish

# 04 Install Apache (with SSL)

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 Installing Apache (with SSL 🙃) 🚀"
echo "🇺🇿    📜 Script Name:  04_install_apache.fish"
echo "🇹🇲    📅 Last Updated: 2024-01-28"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Arguments...
# NONE!"

set PACKAGE_LIST \
	apache2 \
	apache2-bin \
	apache2-data \
	apache2-utils

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Function for error handling
# Usage: handle_error "Error message"

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]

# Function to install packages with error handling
# Usage: install_packages $package_list

set -x DEBIAN_FRONTEND noninteractive

# Add repository for ondrej/apache2
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:ondrej/apache2


# Update package lists
update_package_lists

# Install PHP packages
install_packages $PACKAGE_LIST

announce_success "Apache packages installed successfully!"

# Generate SSL key
echo "🔄 Generating SSL key 🔄"
if not openssl genrsa \
	-out /var/www/provision/ssl/localhost.key \
	2048
	handle_error "Failed to generate SSL key"
end

# Generate self-signed SSL certificate
# Generate self-signed SSL certificate
echo "🔄 Generating self-signed SSL certificate 🔄"
if not openssl req -x509 -nodes \
	-keyout /var/www/provision/ssl/localhost.key \
	-out /var/www/provision/ssl/localhost.cert \
	-days 3650 \
	-subj "/CN=\\*.localhost" 2>/dev/null

	handle_error "Failed to generate self-signed SSL certificate"
end

announce_success "SSL files generated successfully!"

# Display information about the generated certificate
openssl x509 -noout -text -in /var/www/provision/ssl/localhost.cert

# Copy web server files into place
yes | cp /var/www/provision/vhosts/local.conf /etc/apache2/sites-available/
yes | cp /var/www/provision/html/index.htm /var/www/html/
yes | cp /var/www/provision/ssl/* /etc/apache2/sites-available/

# Set permissions on web server files
sudo chmod -R 755 /var/www/html/*
sudo chmod 600 /etc/apache2/sites-available/localhost.key

a2ensite local.conf
a2dissite 000-default
a2enmod rewrite
a2enmod ssl

service apache2 restart

announce_success "Apache Installed Successfully! ✅"

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 Apache Installed ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
```

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
<VirtualHost *:80 *:443>
	ServerAdmin admin@example.com
    DocumentRoot /var/www/html
    DirectoryIndex index.htm index.html

	# Redirect to HTTPS
	<If "%{SERVER_PORT} == '80'">
		Redirect permanent / https://localhost/
	</If>

	SSLEngine on
	SSLCertificateFile /etc/apache2/sites-available/localhost.cert
	SSLCertificateKeyFile /etc/apache2/sites-available/localhost.key

	<Directory /var/www/html>
		Options Indexes FollowSymLinks
		AllowOverride All
		Require all granted
	</Directory>

	ErrorLog "/var/log/apache2/localhost_error_log"
	CustomLog "/var/log/apache2/localhost_access_log" common
</VirtualHost>
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 04 Install Apache (with SSL)
# Updated: 2024-01-28

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane" # "Europe/London"
VM_IP               = "192.168.42.100"

# Synced Folders
HOST_FOLDER         = "."
REMOTE_FOLDER       = "/var/www"

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
	config.vm.provision :shell, path: "provision/scripts/04_install_apache.fish"

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_04 ./Vagrantfile
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

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [03 Install Utilities](./03_Install_Utilities.md)
| [**Back to Steps**](../README.md)
| [05 Install PHP](./05_Install_PHP.md)
|
