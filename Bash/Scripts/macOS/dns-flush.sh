#!/bin/sh
# Operating System: macOS

# Check if the script is being run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!"
    exit 1
fi

# Clear the mDNSResponder cache
if ! killall -HUP mDNSResponder; then
    echo "Failed to reset mDNSResponder. Are you running this as root or with the necessary permissions?"
    exit 1
fi

# Clear the directory service cache
if ! dscacheutil -flushcache; then
    echo "Failed to flush the directory service cache."
    exit 1
fi

echo "DNS cache cleared successfully!"

