#!/bin/fish

# 05 Install Swift (optional)

set script_name     "install_swift.fish"
set updated_date    "2024-02-13"

set active_title    "Installing Swift"
set job_complete    "Swift Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

# Arguments...
set SWIFT_VERSION  $argv[1]

# Script variables...
# NONE!"

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	binutils \
	libc6-dev \
	libcurl4-openssl-dev \
	libcurl4 \
	libedit2 \
	libgcc-9-dev \
	libpython2.7 \
	libpython3.8 \
	libsqlite3-0 \
	libstdc++-9-dev \
	libxml2-dev \
	libxml2 \
	libz3-dev \
	pkg-config \
	tzdata \
	uuid-dev \
	zlib1g-dev

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to install Swift
# Usage: install_swift
function install_swift
	update_and_install_packages $SWIFT_PACKAGES

	echo "⬇️ Downloading Swift ⬇️"
	set SWIFT_FILENAME_BASE "swift-$SWIFT_VERSION-RELEASE-ubuntu20.04-aarch64"
	set SWIFT_URL_BASE "https://download.swift.org/swift-$SWIFT_VERSION-release/ubuntu2004-aarch64/swift-$SWIFT_VERSION-RELEASE"
	curl -L -O $SWIFT_URL_BASE/$SWIFT_FILENAME_BASE.tar.gz
	curl -L -O $SWIFT_URL_BASE/$SWIFT_FILENAME_BASE.tar.gz.sig

	echo "🕵️ Verifying download 🕵️"
	wget -q -O - https://swift.org/keys/release-key-swift-5.x.asc | gpg --import -
	gpg --keyserver hkp://keyserver.ubuntu.com --refresh-keys Swift
	gpg --verify $SWIFT_FILENAME_BASE.tar.gz.sig

	echo "🔄 Installing Swift 🔄"
	tar xzf swift-5.9.2-RELEASE-ubuntu20.04-aarch64.tar.gz
	mv swift-5.9.2-RELEASE-ubuntu20.04-aarch64 /usr/share/swift
	ln -s /usr/share/swift/usr/bin/swift /usr/bin/swift

	# Add Swift binary path to PATH
	echo "export PATH=/usr/share/swift/usr/bin:$PATH" >> /home/vagrant/.bashrc
	source /home/vagrant/.bashrc

	# Cleanup
	rm -f swift-5.9.2-RELEASE-ubuntu20.04-aarch64.*
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function advance_vm
	# Header banner
	header_banner "$active_title" "$script_name" "$updated_date"

	set -x DEBIAN_FRONTEND noninteractive

	install_swift

	# Footer banner
	footer_banner "$job_complete"
end

advance_vm
