# 04 Install Swift (optional)

Updated: 2024-02-14

--

Swift can be installed at any time after this, so I'm putting it here. It can be skipped entirely, or come back to later.

🚨 Swift adds more than `5 GB` to the size of your VM, so think about installing it.

### Create `provision/scripts/install_swift.fish`

```
#!/bin/bash

# 04 Install Swift (optional)

script_name="install_swift.sh"
updated_date="2024-02-13"

active_title="Installing Swift"
job_complete="Swift Installed"

# Source common functions
source /var/www/provision/scripts/_banners.sh
source /var/www/provision/scripts/_common.sh

# Arguments...
SWIFT_VERSION="$1"

# Script variables...
# NONE!"

# Always set package_list when using...
# install_packages() or update_and_install_packages()
package_list=(
	"binutils"
	"libc6-dev"
	"libcurl4-openssl-dev"
	"libcurl4"
	"libedit2"
	"libgcc-9-dev"
	"libpython2.7"
	"libpython3.8"
	"libsqlite3-0"
	"libstdc++-9-dev"
	"libxml2-dev"
	"libxml2"
	"libz3-dev"
	"pkg-config"
	"tzdata"
	"uuid-dev"
	"zlib1g-dev"
)

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to install Swift
# Usage: install_swift
function install_swift() {
	echo "⬇️ Downloading Swift ⬇️"
	swift_filename_base="swift-$SWIFT_VERSION-RELEASE-ubuntu20.04-aarch64"
	swift_url_base="https://download.swift.org/swift-$SWIFT_VERSION-release/ubuntu2004-aarch64/swift-$SWIFT_VERSION-RELEASE"
	curl -L -O "$swift_url_base/$swift_filename_base.tar.gz"
	curl -L -O "$swift_url_base/$swift_filename_base.tar.gz.sig"

	echo "🕵️ Verifying download 🕵️"
	wget -q -O - https://swift.org/keys/release-key-swift-5.x.asc | gpg --import -
	gpg --keyserver hkp://keyserver.ubuntu.com --refresh-keys Swift
	gpg --verify "$swift_filename_base.tar.gz.sig"

	echo "🔄 Installing Swift 🔄"
	tar xzf "$swift_filename_base.tar.gz"
	mv "$swift_filename_base" /usr/share/swift
	ln -s "/usr/share/swift/usr/bin/swift" /usr/bin/swift

	# Add Swift binary path to PATH
	echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> /home/vagrant/.bashrc
	source /home/vagrant/.bashrc

	# Cleanup
	rm -f "$swift_filename_base".*
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

function provision() {
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	export DEBIAN_FRONTEND=noninteractive

	update_and_install_packages $package_list
	install_swift

	# Footer banner
	footer_banner "$job_complete"
}

provision
```

### Update `Vagrantfile`

```
# -*- mode: ruby -*-
# vi: set ft=ruby

# 04 Install Swift (optional)
# Generated: 2024-02-14

# Machine Variables
VM_HOSTNAME         = "p2vagrant"
VM_IP               = "192.168.22.42"
TIMEZONE            = "Australia/Brisbane"
MEMORY              = 4096
CPUS                = 1

# Synced Folders
HOST_FOLDER         = "."
VM_FOLDER           = "/var/www"

# Software Versions
SWIFT_VERSION       = "5.9.2"

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
	config.vm.synced_folder HOST_FOLDER, VM_FOLDER, create: true, nfs: true, mount_options: ["actimeo=2"]

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: "always"

	# Provisioning...
#	config.vm.provision :shell, path: "provision/scripts/install_utilities.sh", args: [TIMEZONE]
	config.vm.provision :shell, path: "provision/scripts/install_swift.sh", args: [SWIFT_VERSION]

end
```

* **Note:** From here on, all but the last provisioning script call will be commented out. If you want to run more than one step at once, simply uncomment the earlier lines.

Or run...

```
./vg 4
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

### Check that Swift is Working

```
vagrant ssh
swift -v
```

For output like...

```
Swift version 5.9.2 (swift-5.9.2-RELEASE)
Target: aarch64-unknown-linux-gnu
/usr/share/swift/usr/bin/swift-help intro

Welcome to Swift!

Subcommands:

  swift build      Build Swift packages
  swift package    Create and work on packages
  swift run        Run a program from a package
  swift test       Run package tests
  swift repl       Experiment with Swift code interactively
```

### All good?

Save the moment with a [Snapshot](./Snapshots.md).

--

<!-- 04 Install Swift (optional) -->
| [03 Install Utilities](./03_Install_Utilities.md)
| [**Back to Steps**](../README.md)
| [05 Install Apache (with SSL & Markdown)](./05_Install_Apache.md)
|

--

p2vagrant - &copy; 2024, Pedro Plowman, Australia 🇦🇺 🇺🇦 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳

--
