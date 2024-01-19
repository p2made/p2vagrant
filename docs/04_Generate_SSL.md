# 04 Generate SSL

--

### Create `provision/scripts/generate_ssl.sh`

```
#!/bin/bash

# 03 Generate Self-Signed SSL Certificate

# Variables...
# 1 - SSL_DIR         = "/var/www/provision/ssl"
# 2 - CERT_NAME       = "p2_selfsigned"

echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🚀 Generating Self-Signed SSL Certificate 🚀"
echo "Script Name:  generate_ssl.sh"
echo "Last Updated: 2024-01-20"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
echo ""

export DEBIAN_FRONTEND=noninteractive

# Create SSL directory
mkdir -p $1

# Generate private key and certificate
openssl req -x509 -nodes -days 999 -newkey rsa:2048 \
  -keyout $1/$2.key -out $1/$2.crt \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Display information about the generated certificate
openssl x509 -noout -text -in $1/$2.crt

echo ""
echo "⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️"
echo ""
echo "🏆 Self-Signed SSL Certificate Generated ‼️"
echo ""
echo "🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭 🛠️ ⚙️ ⚗️ ⚒️ 🗜 🔭"
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby :

# 04 Generate SSL
# Updated: 2024-01-20

# Machine Variables
MEMORY              = 4096
CPUS                = 1
TIMEZONE            = "Australia/Brisbane"
#TIMEZONE            = "Europe/London"
VM_IP               = "192.168.42.100"
SSL_DIR             = "/var/www/provision/ssl"
CERT_NAME           = "p2_selfsigned"

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

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: 'always'

	# Provisioning...
	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
	config.vm.provision :shell, path: "provision/scripts/generate_ssl.sh", args: [SSL_DIR, CERT_NAME]

end
```

Or copy this file...

```
cp ./Vagrantfiles/Vagrantfile_04 ./Vagrantfile
```

### Provision the VM

```
vagrant reload --provision
```

Or (*only if the VM is running*)...

```
vagrant provision
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

| [03 Install Utilities](./03_Install_Utilities.md)
| [**Back to Steps**](../README.md)
| [05 Install Apache](./05_Install_Apache.md)
|
