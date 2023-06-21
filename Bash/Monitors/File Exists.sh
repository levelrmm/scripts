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
# Name: Linux Monitor - File Existence
# Description: This recurring script checks for the existence of a specific file.
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - File Existence
# Script output: Contains
# Output value: "file exists" or "not found"
# Run frequency: Minutes
# Duration: 1
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - file_path

# Specify the file path to check for existence
file_path="/path/to/file.txt"
# -----------------------------------------------------------------------------

# Check if the file exists
if [ -f "$file_path" ]; then
  echo "file exists: $file_path"
else
  echo "file not found: $file_path"
fi
