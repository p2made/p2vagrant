#!/bin/zsh

# provision/vm/vm_vagrant.sh

# Usage:
# ./provision/vm/vm_vagrant.sh "$(pwd)" "$provisioning_step" "$requires_vagrantfile"

# Common functions
source ./vm_common.sh

# Source data
source ../data/vm_data.sh

# Change working directory to the 'vm' directory
cd "$1"

# Access the values of passed arguments
provisioning_step=$2
requires_vagrantfile=$3

if (( $provisioning_step == 0 )); then
	vagrant up
	return 0
fi

declare current_vagrantfile

if [[ -e ./Vagrantfile ]]; then
	# Read the two digits from the Vagrantfile
	vagrantfile_line=$(head -n 4 ./Vagrantfile | tail -n 1)
	if [[ $vagrantfile_line =~ ([0-9]+) ]]; then
		current_vagrantfile=${BASH_REMATCH[1]}
		# Convert to an integer
		current_vagrantfile=$((10#$current_vagrantfile))
	fi
fi

function vagrant_action
