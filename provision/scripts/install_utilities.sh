#!/bin/bash

# 03 Install Utilities (& optionally Swift)

script_name="install_utilities.sh"
updated_date="2024-02-08"

active_title="Installing Utilities"
job_complete="Utilities Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.sh

header_banner "$active_title" "$script_name" "$updated_date"
# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
SWIFT_VERSION=$1    # false - "5.9.2" if Swift is required

# Always set PACKAGE_LIST when using update_and_install_packages
PACKAGE_LIST=(
	"apt-transport-https"
	"bzip2"
	"ca-certificates"
	"curl"
	"debconf-utils"
	"expect"
	"file"
	"fish"
	"git"
	"gnupg2"
	"gzip"
	"libapr1"
	"libaprutil1"
	"libaprutil1-dbd-sqlite3"
	"libaprutil1-ldap"
	"liblua5.3-0"
	"lsb-release"
	"mime-support"
	"nodejs"
	"npm"
	"openssl"
	"software-properties-common"
	"unzip"
	"yarn"
)
SWIFT_PACKAGES=(
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

export DEBIAN_FRONTEND=noninteractive

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Function to set Fish as the default shell
set_fish_as_default_shell() {
	if ! sudo usermod -s /usr/bin/fish vagrant; then
		handle_error "Failed to set Fish shell as default"
	fi

	sudo chsh -s /usr/bin/fish vagrant

	echo "🐟 Default shell set to Fish shell https://fishshell.com 🐠"
}

# Function to install (optionally) Swift
install_swift() {
	echo "🚀 Installing Swift 🦜"
	install_packages $SWIFT_PACKAGES
	SWIFT_FILENAME_BASE="swift-$SWIFT_VERSION-RELEASE-ubuntu20.04-aarch64"
	SWIFT_URL_BASE="https://download.swift.org/swift-$SWIFT_VERSION-release/ubuntu2004-aarch64/swift-$SWIFT_VERSION-RELEASE"
	echo "⬇️ Downloading Swift ⬇️"
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
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Add Fish Shell repository
LC_ALL=C.UTF-8 apt-add-repository -yu ppa:fish-shell/release-3

install_packages $PACKAGE_LIST

if [ "$SWIFT_VERSION" != "false" ]; then
	install_swift
fi

set_fish_as_default_shell # Let's swim 🐟🐠🐟🐠🐟🐠

# Append the 'cd /var/www' line to .profile if it doesn't exist
grep -qxF 'cd /var/www' /home/vagrant/.profile || \
	echo 'cd /var/www' >> /home/vagrant/.profile

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner "$job_complete"
