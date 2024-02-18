#!/bin/zsh

# provision/scripts/vm_common.sh

# Usage...
# `source ./relative/path/to/vm_common.sh"`

# Function for error handling
# Usage: handle_error "Error message"
function handle_error() {
	echo "⚠️   Error: $1 💥"
	echo "Run 'vagrant halt' then restore the last snapshot before trying again."
	exit 1
}

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success() {
	icon="✅"

	if [ -n "$2" ] && [ "$2" -eq 1 ]; then
		icon="👍"
	fi

	echo "$icon  $1"
}

# Function to announce a job not needing to be done
# Usage: announce_no_job "Nothing to do."
function announce_no_job() {
	echo "👍  $1"
}

function debug_message() {
	echo "‼️‼️  Debug: $1 🚨"
}
