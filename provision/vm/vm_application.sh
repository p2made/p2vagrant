#!/bin/zsh

# vm_application.sh

# Generates Vagrantfile for the step specified by an integer argument.
# &/or deletes previously generated & copied files
# For usage run `./vm`

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

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to process flags
# Usage: process_flags [$FLAGS]
process_flags() {
	# Use globals
	# FLAGS="grv"
	# FLAG_GENERATE=false
	# FLAG_RESET=false
	# FLAG_VAGRANT=false

	# If no options are provided, set FLAG_GENERATE to true
	if [ "$#" -eq 0 ]; then
		return
	fi

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
}

# Function to evaluate the argument
# Usage: evaluate_argument $argument
function evaluate_argument() {
	local argument=$1

	# Check the argument
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
	passed_step=$argument
	vf_index=$argument

	# Check whether a Vagrantfile is needed for this step
	if ! [[ "${VAGRANTFILES_INDEXES[@]}" =~ "${passed_step}" ]]; then
		requires_vagrantfile=true
	fi
}

function shift_vagrantfile_index() {
	# This is a step that is manually provisioned,
	# so we generate the Vagrantfile for the step before.
	# Iterate through the array
	for element in "${VAGRANTFILES_INDEXES[@]}"; do
		# Check if the element is less than or equal to n
		if ((element <= $passed_step)); then
			# Update the result with the largest element so far
			vf_index=$element
			requires_vagrantfile=true
		else
			return
		fi
	done

}

function vagrant_manager() {
	vm_application_banner

	# Set variables up
	declare passed_step
	declare vf_index
	requires_vagrantfile=false
	current_vagrantfile=0

	process_flags

	# Shift to the next argument after processing flags
	shift $(( OPTIND - 1 ))

	# If we have come this far, we have an argument to evaluate.
	evaluate_argument "$1"

	# If `-r` is set, perform reset
	if $FLAG_RESET; then
		./provision/vm/vm_reset.sh "$(pwd)" "$passed_step"

		# `-g` is always implicit, but `$requires_vagrantfile` can change things
		if ! $requires_vagrantfile; then
			shift_vagrantfile_index
		fi
	fi

	if ! $requires_vagrantfile: then
		handle_error "Step $passed_step does not require a Vagrantfile"
	fi

	local vf_title=$VAGRANTFILES[$vf_index]
	./provision/vm/vm_generate.sh "$(pwd)" "$vf_index" "$vf_title"

	# If `-v` is set
	if $FLAG_VAGRANT; then
		./provision/vm/vm_vagrant.sh "$(pwd)" "$passed_step" "$requires_vagrantfile"
	fi
}
