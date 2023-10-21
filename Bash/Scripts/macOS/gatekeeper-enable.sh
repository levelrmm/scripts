#!/bin/sh
# Operating System: macOS
# This script enables the macOS Gatekeeper, which helps protect against 
# unidentified and potentially malicious applications from being opened.

# Ensure the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root." 
    exit 1
fi

# Check if Gatekeeper is already enabled
GATEKEEPER_STATUS=$(spctl --status)
if [ "$GATEKEEPER_STATUS" != "assessments enabled" ]; then
	# Enable Gatekeeper
	spctl --global-enable
	
	# Error check
	if [ $? -eq 0 ]; then
	    echo "Gatekeeper has been successfully enabled."
	else
	    echo "Failed to enable Gatekeeper. Please check for errors."
	    exit 1
	fi
else
	echo "Gatekeeper is already enabled."
fi


