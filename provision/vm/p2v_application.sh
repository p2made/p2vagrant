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

# Function to check p2v init state
# by whether p2v_prefs.yaml exists
# Usage: check_init
function check_init() {
	if [ ! -f "$P2V_PREFS" ]; then
		local message="p2v prefs not found. Would you like to initialize p2v?"
		if ask_no_yes "$message"; then
			# Call the initialization function or script
			./provision/vm/p2v_init.sh "$(pwd)"
		fi
	fi
}

# Function to process flags
# Usage: process_flags "$@"
function process_flags() {
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

# Function to evaluate argument
# Usage: passed_index=$(evaluate_argument "$argument")
function evaluate_argument() {
	local argument=$1

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

	# Return the valid argument
	printf "%s" "$argument"
}

# Function to load prefs
# Usage: load_prefs
function load_prefs() {
	VM_USERNAME=$(read_yaml_value "VM_USERNAME")
	VM_HOSTNAME=$(read_yaml_value "VM_HOSTNAME")
	VM_IP=$(read_yaml_value "VM_IP")
	TIMEZONE=$(read_yaml_value "TIMEZONE")
	MEMORY=$(read_yaml_value "MEMORY")
	CPUS=$(read_yaml_value "CPUS")
	HOST_FOLDER=$(read_yaml_value "HOST_FOLDER")
	VM_FOLDER=$(read_yaml_value "VM_FOLDER")
	PHP_VERSION=$(read_yaml_value "PHP_VERSION")
	MYSQL_VERSION=$(read_yaml_value "MYSQL_VERSION")
	SWIFT_VERSION=$(read_yaml_value "SWIFT_VERSION")
	ROOT_PASSWORD=$(read_yaml_value "ROOT_PASSWORD")
	DB_USERNAME=$(read_yaml_value "DB_USERNAME")
	DB_PASSWORD=$(read_yaml_value "DB_PASSWORD")
	DB_NAME=$(read_yaml_value "DB_NAME")
	DB_NAME_TEST=$(read_yaml_value "DB_NAME_TEST")
	VM_TLDS=($(yq -r ".VM_TLDS[]" "$P2V_PREFS"))
	ZENITY_MAC=$(read_yaml_value "ZENITY_MAC")
	ZENITY_VM=$(read_yaml_value "ZENITY_VM")
	HELLO_MAC=$(read_yaml_value "HELLO_MAC")
	HELLO_VM=$(read_yaml_value "HELLO_VM")
	OPTIONS_MAC=$(read_yaml_value "OPTIONS_MAC")
	OPTIONS_VM=$(read_yaml_value "OPTIONS_VM")
}

# Function to check whether a step requires a Vagrantfile
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

# Function to reset p2vagrant
# Usage: handle_reset
function handle_reset() {
	if ! $FLAG_RESET; then
		return
	fi

	#./provision/vm/p2v_reset.sh "$(pwd)" "$passed_index"
	debug_message "$FUNCNAME" "$LINENO" "Reset action would be done here"

	# Set `requires_vagrantfile` with shift
	set_requires_vagrantfile "$passed_index" true
}

# Function to generate Vagrantfile
# Usage: handle_generate
function handle_generate() {
	set_requires_vagrantfile "$vagrantfile_index"

	if ! $requires_vagrantfile; then
		handle_error "Step $vagrantfile_index does not require a Vagrantfile"
	fi

	local vagrantfile_title=$VAGRANTFILES[$vagrantfile_index]
	./provision/vm/p2v_generate.sh "$(pwd)" "$vagrantfile_index" "$vagrantfile_title"
}

# Function to start the VM appropriately
# Usage: handle_vagrant
function handle_vagrant() {
	if ! $FLAG_VAGRANT; then
		return
	fi

	set_requires_vagrantfile "$passed_index"
	./provision/vm/p2v_vagrant.sh "$(pwd)" "$requires_vagrantfile"
}

# Core Vagrant Manager application function
# Usage: p2v "$@"
p2v() {
	p2v_application_banner  # Show banner
	check_init              # Check for existence prefs
	process_flags "$@"      # Process flags

	shift $(( OPTIND - 1 )) # Shift to the next argument

	# If we have come this far, we might have an argument to evaluate.
	passed_index=$(evaluate_argument "$argument")
	vagrantfile_index=$passed_index

	load_prefs              # Now we can load prefs

	handle_reset            # If `-r` is set, perform reset
	handle_generate         # `-g` is always set so generate Vagrantfile
	handle_vagrant          # If `-v` is set run start or reload the VM appropriately
}

# debug_message "$LINENO" "Message"
