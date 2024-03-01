#!/bin/zsh

# provision/vm/p2v_generate.sh

# Usage:
# `./provision/vm/p2v_generate.sh "$(pwd)" "$vagrantfile_index" "$vagrantfile_title"`

# Common functions
source ./provision/vm/p2v_common.sh

# Source data
source ./provision/data/p2v_data.sh

# Change working directory to the 'vm' directory
cd "$1"

# Access the value of $vagrantfile_index passed as an argument
vagrantfile_index=$2
td=$(printf "%02d" $vagrantfile_index)
vagrantfile_title=$3

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to get the step title from sparse array in data
announce_success "Generating Vagrantfile for $td: $vagrantfile_title."

# Use a here document for the Vagrantfile content
cat <<EOF > ./Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby

# $td $vagrantfile_title
# Generated: $(date "+%Y-%m-%d")

# Machine Variables
VM_HOSTNAME         = "$VM_HOSTNAME"
VM_IP               = "$VM_IP"
TIMEZONE            = "$TIMEZONE"
MEMORY              = $MEMORY
CPUS                = $CPUS

# Synced Folders
HOST_FOLDER         = "$HOST_FOLDER"
VM_FOLDER           = "$VM_FOLDER"
EOF

if (( vagrantfile_index >= 4 )); then
	cat <<EOF >> ./Vagrantfile

# Software Versions
SWIFT_VERSION       = "$SWIFT_VERSION"
EOF
fi

if (( vagrantfile_index >= 6 )); then
	cat <<EOF >> ./Vagrantfile
PHP_VERSION         = "$PHP_VERSION"
EOF
fi

if (( vagrantfile_index >= 7 )); then
	cat <<EOF >> ./Vagrantfile
MYSQL_VERSION       = "$MYSQL_VERSION"

# Database Variables
ROOT_PASSWORD       = "$ROOT_PASSWORD"
DB_USERNAME         = "$DB_USERNAME"
DB_PASSWORD         = "$DB_PASSWORD"
DB_NAME             = "$DB_NAME"
DB_NAME_TEST        = "$DB_NAME_TEST"
EOF
fi

# VM config opening lines
cat <<EOF >> ./Vagrantfile

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
EOF

# VM config provisioning lines
if (( vagrantfile_index >= 2 )); then
	cat <<EOF >> ./Vagrantfile

	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: "always"
EOF
fi

if (( vagrantfile_index >= 3 )); then
	echo -e "\n\t# Provisioning..." >> ./Vagrantfile

	# Loop through keys of the associative array in sorted order
	for provisioning_step in "${PROVISIONING_INDEXES[@]}"; do
		provisioning_string=$PROVISIONING_ITEMS[$provisioning_step]
		if (( $vagrantfile_index <= $provisioning_step )); then
			if (( $vagrantfile_index == $provisioning_step )); then
				echo -e "\t$provisioning_string\n" >> ./Vagrantfile
			fi
			break
		fi
		echo -e "#\t$provisioning_string" >> ./Vagrantfile
	done
fi

# VM config closing lines
echo -e "end" >> ./Vagrantfile

# debug_message "$FUNCNAME" "$LINENO" "Message"
