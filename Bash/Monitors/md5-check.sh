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
# Name: Linux Monitor - MD5 Check
# Description: This script compares the MD5 hash of a file with a supplied hash.
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - MD5 Check
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - file_path
# - supplied_hash

# File path of the file to check
file_path="/path/to/file"

# Expected MD5 hash value
supplied_hash=""

# -----------------------------------------------------------------------------

# Check if the file exists
if [ ! -f "$file_path" ]; then
  echo "ALERT: File does not exist: $file_path"
  exit 1
fi

# Calculate the MD5 hash of the file
calculated_hash=$(md5sum "$file_path" | awk '{print $1}')

# Compare the calculated hash with the supplied hash
if [ "$calculated_hash" == "$supplied_hash" ]; then
  echo "SUCCESS: The MD5 hash of $file_path matches the supplied hash."
else
  echo "ALERT: The MD5 hash of $file_path does not match the supplied hash."
  echo "Expected hash: $supplied_hash"
  echo "Calculated hash: $calculated_hash"
fi
