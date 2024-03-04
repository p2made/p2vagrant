#!/bin/zsh

# p2v_application.sh

# The main Vagrant Manager application file

# Common Functions
source ./provision/vm/p2v_common.sh

# Script constants
FLAGS="grv"
#FLAGS="grvi"

# Define flags & defaults
FLAG_GENERATE=true
FLAG_RESET=false
FLAG_VAGRANT=false

# Set variables up
declare passed_index
declare vagrantfile_index
declare requires_vagrantfile

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Function to check whether a step requires a Vagrantfile
# Use true for `$shift_index` to shift `$vagrantfile_index`
# back to the last step requiring a Vagrantfile.
# Usage: set_requires_vagrantfile "$step_index" [$shift_index]
function set_requires_vagrantfile() {
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

	handle_error "Unable to set \$requires_vagrantfile"
}

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- -- #

# Core Vagrant Manager application function
# Usage: p2v "$@"
p2v() {
	# Fly the banner
	p2v_application_banner

	# Check for prefs file
	p2v_prefs true

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
#			i)
#				FLAG_INFO=true
#				;;
			\?)
				handle_error "Invalid option: -$OPTARG"
				;;
			:)
				handle_error "Option -$OPTARG requires an argument."
				;;
		esac
	done

	shift $(( OPTIND - 1 ))
	local argument=$1

	# Evaluate argument
	if [ -z "$argument" ]; then
		# No argument
		handle_error "An integer argument is required"
	elif ! [[ $argument =~ ^[0-9]+$ ]]; then
		# Not an integer
		handle_error "$argument is not a valid integer"
	elif (( $argument < 1 )); then
		# Less than 1
		handle_error "<integer> argument must be greater than zero"
	elif (( $argument > $VAGRANTFILES_INDEXES[-1] )); then
		# Out of range
		handle_error "$argument is out of range"
	fi

	passed_index=$argument
	vagrantfile_index=$passed_index

	# If `-r` is set, perform reset
	if $FLAG_RESET; then
		#./provision/vm/p2v_reset.sh "$(pwd)" "$passed_index"
		debug_message "$FUNCNAME" "$LINENO" "Reset action would be done here"

		# Set `requires_vagrantfile` with shift
		set_requires_vagrantfile "$passed_index" true
	fi
	# / `-r`

	# `-g` is always set so generate Vagrantfile
	set_requires_vagrantfile "$vagrantfile_index"

	if ! $requires_vagrantfile; then
		handle_error "Step $vagrantfile_index does not require a Vagrantfile"
	fi

	local vagrantfile_title=$VAGRANTFILES[$vagrantfile_index]
	./provision/vm/p2v_generate.sh "$(pwd)" "$vagrantfile_index" "$vagrantfile_title"
	# / `-g`

	# If `-v` is set run start or reload the VM appropriately
	if $FLAG_VAGRANT; then
		set_requires_vagrantfile "$passed_index"
		./provision/vm/p2v_vagrant.sh "$(pwd)" "$requires_vagrantfile"
	fi
	# / `-v`
}

# debug_message "$LINENO" "Message"
