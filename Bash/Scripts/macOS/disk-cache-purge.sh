#!/bin/sh
# Operating System: macOS
#
# This script clears inactive and speculative memory in macOS using the 'purge' command.
# WARNING: This might affect system performance temporarily immediately after execution.

# Ensure the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Execute the purge command
purge

echo "Memory cache cleared."

