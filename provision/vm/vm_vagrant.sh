#!/bin/zsh

# provision/vm/vm_vagrant.sh

# Usage:
# `./provision/vm/vm_vagrant.sh "$(pwd)" "$provision"`

# Common functions
source ./provision/vm/vm_common.sh

# Source data
source ./provision/data/vm_data.sh

# Change working directory to the 'vm' directory
cd "$1"

# Access the values of passed arguments
provision=$2



# Run vagrant status and capture the output
status=$(vagrant status)

# Check if the status contains the string "not running"
if [[ $status =~ "not running" ]]; then
    echo "Vagrant is not running."
    # Set a boolean variable or perform other actions accordingly
    is_vagrant_running=false
elif [[ $status =~ "running" ]]; then
    echo "Vagrant is running."
    is_vagrant_running=true
else
    echo "Unable to determine Vagrant status."
    is_vagrant_running=false
fi

# Now you can use the variable $is_vagrant_running in your script


#if (( $provisioning_step == 0 )); then
#	vagrant up
#	return 0
#fi

#declare current_vagrantfile

#if [[ -e ./Vagrantfile ]]; then
#	# Read the two digits from the Vagrantfile
#	vagrantfile_line=$(head -n 4 ./Vagrantfile | tail -n 1)
#	if [[ $vagrantfile_line =~ ([0-9]+) ]]; then
#		current_vagrantfile=${BASH_REMATCH[1]}
#		# Convert to an integer
#		current_vagrantfile=$((10#$current_vagrantfile))
#	fi
#fi

#function vagrant_action
