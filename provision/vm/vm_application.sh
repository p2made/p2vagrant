#!/bin/zsh

# vm_application.sh

# Generates Vagrantfile for the step specified by an integer argument.
# &/or deletes previously generated & copied files
# For usage run `./vm`

# Script constants
FLAGS="g:r:v"

# Define flags
FLAG_GENERATE=false
FLAG_RESET=false
FLAG_VAGRANT=false

# Script variables
provisioning_step=0

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to process flags
# Usage: process_flags [$FLAGS]
function process_flags() {
	# Use globals
	# FLAGS="g:r:v"
	# FLAG_GENERATE=false
	# FLAG_RESET=false
	# FLAG_VAGRANT=false

	# Process flags
	while getopts ":$FLAGS" opt; do
		debug_message "Processing options"
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
				handle_error "Invalid option: -$OPTARG"
				;;
			:)
				if [ ${#OPTARG} -eq 0 ]; then
				    handle_error "Option -$opt requires an argument"
				else
				    handle_error "Invalid option: -$opt"
				fi
				;;
		esac
	done

	# Check if there were no options
	if (( $OPTIND == 1 )); then
		# Set default behavior or handle as needed
		FLAG_GENERATE=true
	fi
}

# Function to evaluate the argument
# Usage: evaluate_argument $argument
function evaluate_argument() {
	local argument=$1

	# Check if the argument is an integer
	if ! [[ $argument =~ ^[0-9]*$ ]]; then
		handle_error "$argument is not a valid integer"
	fi

	# Check is argument is out of range
	if (( $argument > $VAGRANTFILES_INDEXES[-1] )); then
		handle_error "$argument is out of range"
	fi

	if (( ${#argument} == 0 )); then
		argument=0
	fi

	# Now argument is valid for `-r` at minimum
	passed_step=$argument

	# Check whether a Vagrantfile is needed for this step
	if ! [[ "${VAGRANTFILES_INDEXES[@]}" =~ "${passed_step}" ]]; then
		requires_vagrantfile=true
	fi
}

# Function to set up for & then run `./provision/vm/vm_generate.sh`
# Usage: generate_action "$passed_step" "$requires_vagrantfile"
function generate_action() {
	local passed_step=$1

	if ! $2; then
		handle_error "Step $passed_step does not require a Vagrantfile"
	fi

	./provision/vm/vm_generate.sh "$(pwd)" "$passed_step"
}

# Function to set up for & then run `./provision/vm/vm_reset.sh`
# Usage: reset_action "$passed_step" "$requires_vagrantfile"
function reset_action() {
	local reset_step=$1
	local requires_vagrantfile=$2

	./provision/vm/vm_reset.sh "$(pwd)" "$reset_step"

	# `-g` is always implicit, but `$requires_vagrantfile` can change things
	step_vagrantfile="$reset_step"
	if ! $requires_vagrantfile; then
		# This is a step that is manually provisioned,
		# so we generate the Vagrantfile for the step before.
		step_vagrantfile="$reset_step"-1
	fi
}

# Function to set up for & then run `./provision/vm/vm_vagrant.sh`
# Usage: vagrant_action "$provisioning_step" "$requires_vagrantfile"
function vagrant_action() {

	./provision/vm/vm_vagrant.sh "$(pwd)" "$provisioning_step" "$requires_vagrantfile"
}

# Function to eliminate zero argument after it is no longer valid
# Usage: eliminate_zero_argument "$passed_step"
function eliminate_zero_argument() {
	if (( $1 > 0 )); then
		return
	fi

	if $FLAG_RESET; then
		handle_error "Resetting p2vagrant requires a non-zero integer argument"
	fi

	handle_error "Generating a Vagrantfile requires a non-zero integer argument"
}

function vagrant_manager() {
	vm_application_banner

	# Set variables up
	declare passed_step
	declare step_vagrantfile
	requires_vagrantfile=false
	current_vagrantfile=0

	process_flags

	# Shift to the next argument after processing flags
	shift $(( OPTIND - 1 ))

	# If we have come past the previous check, we have an argument to evaluate.
	evaluate_argument "$1"

	# if only `-v` is set
	if $FLAG_VAGRANT && ! $FLAG_GENERATE && ! $FLAG_RESET; then
		vagrant_action "$passed_step" "$requires_vagrantfile"
		exit 0
	fi

	# After this `$passed_step` must be greater than zero
	eliminate_zero_argument $passed_step

	# if only `-g` is set
	if $FLAG_GENERATE && ! $FLAG_RESET && ! $FLAG_VAGRANT; then
		generate_action "$passed_step" "$requires_vagrantfile"
		exit 0
	fi

	# if `-r` is set
	if $FLAG_RESET; then
		reset_action "$passed_step" "$requires_vagrantfile"
		generate_action "$step_vagrantfile" "$requires_vagrantfile"
	fi

	# if we get this far & `-v` is set
	if $FLAG_VAGRANT; then
		vagrant_action
		exit 0
	fi
}
