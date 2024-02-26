#!/bin/bash

# 04 Install Swift (optional)

script_name="install_swift.sh"
updated_date="2024-02-13"

active_title="Installing Swift"
job_complete="Swift Installed"

# Source common functions
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
	header_banner "$active_title" "$script_name" "$updated_date" false

	export DEBIAN_FRONTEND=noninteractive

	update_and_install_packages $package_list
	install_swift

	# Footer banner
	footer_banner "$job_complete"
}

provision
