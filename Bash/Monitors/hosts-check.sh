#!/bin/bash

# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Linux Monitor - Host File Changes
# Description: This script monitors for non-excluded entries in the host file
# and alerts if any modifications are detected.
#
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - Host File Changes
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - host_file_path
# - excluded_entries

# Path to the host file
hostFilePath="/etc/hosts"

# Array of excluded entries (default: "127.0.0.1" and "::1")
excludedEntries=("127.0.0.1" "::1")

# -----------------------------------------------------------------------------

# Function to check for non-excluded entries in the host file
check_host_file_changes() {
    local filePath=$1
    local excluded=("${@:2}")

    if [[ -f "$filePath" ]]; then
        while IFS= read -r line; do
            entry=$(echo "$line" | awk '{$1=$1};1') # Remove leading/trailing whitespaces
            if [[ ! -z "$entry" && "$entry" != "#"* ]]; then
                ipAddress=$(echo "$entry" | awk '{print $1}')
                if ! contains_element "$ipAddress" "${excluded[@]}"; then
                    echo "ALERT: Non-excluded entry detected in the host file: $entry"
                    exit 1
                fi
            fi
        done < "$filePath"
    fi
}

# Function to check if an element exists in an array
contains_element() {
    local searchElement=$1
    shift
    local array=("$@")
    for element in "${array[@]}"; do
        if [[ "$element" == "$searchElement" ]]; then
            return 0
        fi
    done
    return 1
}

# Check for non-excluded entries in the host file
check_host_file_changes "$hostFilePath" "${excludedEntries[@]}"
