#!/bin/zsh

# provision/vm/vm_generate.sh

# Usage:
# ./provision/vm/vm_generate.sh "$(pwd)" "$provisioning_step"

# Common functions
source ./vm_common.sh

# Source data
source ../data/vm_data.sh

# Change working directory to the 'vm' directory
cd "$1"

# Access the value of $provisioning_step passed as an argument
provisioning_step=$2
vm_two=$(printf "%02d" $provisioning_step)
vm_title=$VAGRANTFILES[$provisioning_step]

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to get the step title from sparse array in data
announce_success "Generating Vagrantfile for $vm_two: $vm_title."

# Use a here document for the Vagrantfile content
cat <<EOF > ./Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby

# $vm_two $vm_title
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

if (( provisioning_step >= 4 )); then
    cat <<EOF >> ./Vagrantfile
# Software Versions
SWIFT_VERSION       = "$SWIFT_VERSION"
EOF
fi

if (( provisioning_step >= 6 )); then
    cat <<EOF >> ./Vagrantfile
PHP_VERSION         = "$PHP_VERSION"
EOF
fi

if (( provisioning_step >= 7 )); then
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
if (( provisioning_step >= 2 )); then
    cat <<EOF >> ./Vagrantfile
	# Upgrade check...
	config.vm.provision :shell, path: "provision/scripts/upgrade_vm.sh", run: "always"
EOF
fi

if (( provisioning_step >= 3 )); then
    cat <<EOF >> ./Vagrantfile
	# Provisioning...
EOF

    # Loop through keys of the associative array in sorted order
    for prov_step in "${provisioning_indexes[@]}"; do
        prov_string=$provisioning_items[$prov_step]
        if (( $provisioning_step <= $prov_step )); then
            if (( $provisioning_step == $prov_step )); then
                cat <<EOF >> ./Vagrantfile
	$prov_string
EOF
            fi
            break
        fi
        cat <<EOF >> ./Vagrantfile
#	$prov_string
EOF
    done
fi

# VM config closing lines
cat <<EOF >> ./Vagrantfile
end
EOF
