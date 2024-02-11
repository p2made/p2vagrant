#!/bin/fish

# 00 _script_title_

set script_name     "00_fish_test.fish"
set updated_date    "2024-02-02"

set active_title    "_active_title_"
set job_complete    "_job_complete_"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date

# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --

# Arguments...
# 1 - TIMEZONE   = "Australia/Brisbane"
# NONE!"

# Script constants...

# GENERATION_DATE     $(date "+%Y-%m-%d")
# VM_FOLDER           /var/www
# SHARED_HTML          $VM_FOLDER/html
# PROVISION_FOLDER    $VM_FOLDER/provision
# PROVISION_DATA      $VM_FOLDER/provision/data
# PROVISION_HTML      $VM_FOLDER/provision/html
# PROVISION_LOGS      $VM_FOLDER/provision/logs
# PROVISION_SCRIPTS   $VM_FOLDER/provision/scripts
# PROVISION_SSL       $VM_FOLDER/provision/ssl
# PROVISION_TEMPLATES $VM_FOLDER/provision/templates
# PROVISION_VHOSTS    $VM_FOLDER/provision/vhosts

# Script variables...

# Always set PACKAGE_LIST when using update_and_install_packages
set PACKAGE_LIST \
	package1 \
	package2

# Script functions...

# Function for error handling
# Usage: handle_error "Error message"

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]

# Function to update package with error handling
# Usage: update_package_lists

# Function to install packages with error handling
# Usage: install_packages $package_list

# Function to update package lists the install packages with error handling
# invokes update_package_lists & install_packages in a single call
# Usage: update_and_install_packages $package_list

set -x DEBIAN_FRONTEND noninteractive

# Start _script_title_ logic...

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Custom functions

# Function form
#function function_name
#    ... Function body ...
#    if not [SOME_CHECK]
#        handle_error "Failed to perform some action."
#    end
#    announce_success "Successfully completed some action." # optional
#end

# Example usage:
#function_name
#function_name argument
#function_name argument1 argument2

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

# Execution

# Add repository if appliciable

# Update package lists & install packages
update_and_install_packages $PACKAGE_LIST

# single line statements
# including calls to functions

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner $job_complete

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --
# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

#!/bin/fish

# 03 Install Swift (optional)

set script_name     "install_swift.fish"
set updated_date    "2024-02-11"

set active_title    "Installing Swift"
set job_complete    "Swift Installed"

# Source common functions
source /var/www/provision/scripts/common_functions.fish

header_banner $active_title $script_name $updated_date
# -- -- /%/ -- -- /%/ -- / script header -- /%/ -- -- /%/ -- --


# Arguments...
set SWIFT_VERSION  $argv[1]

# Script variables...
set PHP_INI        /etc/php/$PHP_VERSION/apache2/php.ini

# Always set PACKAGE_LIST when using update_and_install_packages
# Arguments...
=$1    # "" - "5.9.2" if Swift is required

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

if [ -n "$SWIFT_VERSION" ]; then
	install_swift
fi

set_fish_as_default_shell # Let's swim 🐟🐠🐟🐠🐟🐠

# Append the 'cd /var/www' line to .profile if it doesn't exist
grep -qxF 'cd /var/www' /home/vagrant/.profile || \
	echo 'cd /var/www' >> /home/vagrant/.profile

# -- -- /%/ -- -- /%/ -- script footer -- /%/ -- -- /%/ -- --
footer_banner "$job_complete"
