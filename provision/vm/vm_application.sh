#!/bin/zsh

# vm_application.sh

# The main Vagrant Manager application file

# Common Functions
source ./provision/vm/vm_common.sh

# Source data
source ./provision/data/vm_data.sh

# Script constants
FLAGS="grv"

# Define flags
FLAG_GENERATE=true
FLAG_RESET=false
FLAG_VAGRANT=false

# Set variables up
declare passed_index
declare vagrantfile_index
declare requires_vagrantfile

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to evaluate the argument
# Usage: evaluate_argument $argument
evaluate_argument() {
	local argument=$1

	# Check the argument
	if [ -z "$argument" ]; then
		# No argument
		handle_error "An integer argument is required"
	fi
	if ! [[ $argument =~ ^[0-9]+$ ]]; then
		# Not an integer
		handle_error "$argument is not a valid integer"
	elif (( $argument < 1 )); then
		# Less than 1
		handle_error "<integer> argument must be greater than zero"
	elif (( $argument > $VAGRANTFILES_INDEXES[-1] )); then
		# Out of range
		handle_error "$argument is out of range"
	fi

	# Now argument is valid for `-r` at minimum
	passed_index=$argument
}

# Function to check whether a step requires a Vagrantfile
# Usage: set_requires_vagrantfile "$step_index" [$shift_index]
set_requires_vagrantfile() {
	local local_index=$1
	local shift_index=$2

	# Check whether a Vagrantfile is needed for this step
	if [[ "${VAGRANTFILES_INDEXES[@]}" =~ "${local_index}" ]]; then
		requires_vagrantfile=true
		return 1  # Vagrantfile needed (true)
	fi

	if ! (( $shift_index )); then
		requires_vagrantfile=false
		return 0  # No Vagrantfile needed (false)
	fi

	while ((local_index > 0)); do
		(( local_index-- ))
		if [[ "${VAGRANTFILES_INDEXES[@]}" =~ "${local_index}" ]]; then
			vagrantfile_index=$local_index
			requires_vagrantfile=true
			return 1  # Vagrantfile needed (true)
		fi
	done
}

# Function to check for, & if required, perform reset action
# Usage: reset_action "$passed_index"
reset_action() {
}

# Core Vagrant Manager application function
# Usage: vm "$@"
vm() {
	#vm_application_banner

	# Process flags
	while getopts ":$FLAGS" opt; do
		case $opt in
			g)
				FLAG_GENERATE=true
				;;
			r)
				FLAG_RESET=true
				;;
			v)
				FLAG_VAGRANT=true
				;;
			\?)
				echo "Invalid option: -$OPTARG" >&2
				exit 1
				;;
			:)
				echo "Option -$OPTARG requires an argument." >&2
				exit 1
				;;
		esac
	done

	# Shift to the next argument after processing flags
	shift $(( OPTIND - 1 ))

	# If we have come this far, we have an argument to evaluate.
	evaluate_argument "$1"

	# We start off expecting to generate a Vagrantfile for the passed index.
	vagrantfile_index=$passed_index

	# If `-r` is set, perform reset
	if $FLAG_RESET; then
		local local_index=$1

		#./provision/vm/vm_reset.sh "$(pwd)" "$passed_index"
		debug_message "$FUNCNAME" "$LINENO" "Reset action would be done here"

		# `-g` is always implicit, but `$set_requires_vagrantfile`
		# can change things when also doing a reset
		set_requires_vagrantfile "$passed_index" true
	fi

	# `-g` is always set so generate Vagrantfile
	set_requires_vagrantfile "$vagrantfile_index"

	if ! $requires_vagrantfile; then
		handle_error "Step $vagrantfile_index does not require a Vagrantfile"
	fi

	local vagrantfile_title=$VAGRANTFILES[$vagrantfile_index]
	./provision/vm/vm_generate.sh "$(pwd)" "$vagrantfile_index" "$vagrantfile_title"

	# If `-v` is set run start or reload the VM appropriately
	if $FLAG_VAGRANT; then
		set_requires_vagrantfile "$passed_index"

		#./provision/vm/vm_vagrant.sh "$(pwd)" "$passed_index" "$requires_vagrantfile"
		debug_message "$FUNCNAME" "$LINENO" "Vagrant action would be done here"
	fi
}
#	debug_message "$FUNCNAME" "$LINENO" "Message"
