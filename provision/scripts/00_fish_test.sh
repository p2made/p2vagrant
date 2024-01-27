#!/bin/fish

# 00_fish_test

# Variables...
# 1 - 'true'
# 2 - 'false'
#set ARG_1           $1          # production version
set ARG_1           'true'      # ssh test version
#set ARG_2           $2          # production version
set ARG_2           'false'     # ssh test version

echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🚀 _active_title_ 🚀"
echo "🇺🇿    📜 Script Name:  00_fish_test.sh"
echo "🇹🇲    📅 Last Updated: 2024-01-27"
echo "🇹🇯"
echo "🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯"
echo ""

# Function for error handling
# Usage: handle_error "Error message"
function handle_error
    echo "⚠️ Error: $argv 💥"
    exit 1
end

# Function to announce success
# Usage: announce_success "Task completed successfully." [use_alternate_icon]
function announce_success
    set icon ""
    if test $argv[2] -eq 1
        set icon "✅"
    else
        set icon "👍"
    end

    echo "$icon $argv[1]"
end

set -x DEBIAN_FRONTEND noninteractive

# Start _script_title_ logic...

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

function fish_test_function
    if not $argv
        handle_error "Called failure"
    end

    announce_success "Called success." 0
end

# -- -- /%/ -- -- /%/ -- -- /%/ -- -- /%/ -- --

fish_test_function $ARG_1
fish_test_function $ARG_2

echo ""
echo "🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲 🇺🇿 🇦🇿 🇲🇳 🇰🇿 🇰🇬 🇹🇯 🇹🇲"
echo "🇲🇳"
echo "🇦🇿    🏆 _script_job_complete_ ‼️"
echo "🇺🇿"
echo "🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿 🇹🇲 🇹🇯 🇰🇬 🇰🇿 🇲🇳 🇦🇿 🇺🇿"
