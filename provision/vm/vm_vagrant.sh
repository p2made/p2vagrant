#!/bin/zsh

# provision/vm/vm_vagrant.sh

# Usage:
# `./provision/vm/vm_vagrant.sh "$(pwd)" "$provision"`

# Common functions
source ./provision/vm/vm_common.sh

# Change working directory to the 'vm' directory
cd "$1"

# Access the values of passed arguments
provision=$2

vagrant_command="vagrant"

# "up" will be one dynamically added alternative development progresses.
vagrant_command="$vagrant_command up"

if $provision; then
	vagrant_command="$vagrant_command --provision"
fi

eval $vagrant_command

# debug_message "$FUNCNAME" "$LINENO" "Message"
