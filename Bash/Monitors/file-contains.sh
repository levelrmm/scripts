#!/bin/bash
# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment.  We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Linux Monitor - File Contains
# Description: This script checks the contents of a file for a specific string.
# Language: Bash
# Timeout: 100
# Version: 1.0
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - File Contains
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 1
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - file_path
# - search_string

# Specify the file path to check
file_path="/path/to/file.txt"

# Specify the string to search for in the file
search_string="example"
# -----------------------------------------------------------------------------

# Check if the file exists
if [ -f "$file_path" ]; then
  if grep -q "$search_string" "$file_path"; then
    echo "SUCCESS: The string '$search_string' exists in the file."
  else
    echo "ALERT: The string '$search_string' does not exist in the file."
  fi
else
  echo "ERROR: File not found: $file_path"
fi