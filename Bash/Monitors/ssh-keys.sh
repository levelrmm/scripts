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
# Name: Linux Monitor - SSH Keys
# Description: This recurring script checks for unauthorized SSH key entries 
# in authorized_keys files for all users and alerts if any are found.
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - SSH Keys
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE

# Define the path to the authorized_keys files
authorized_keys_paths=("/home/*/.ssh/authorized_keys" "/root/.ssh/authorized_keys")

# Define the authorized users and keys
declare -A authorized_users=(
  ["key1"]="user1"
  ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5BBBBIN29fjdt1EQ1wJMwLAs9wK7ipmv7HSGT9mIrrUl2OKs2 deploy@level.io"]="deploy" # example
)
# -----------------------------------------------------------------------------

# Array to store the list of unauthorized keys and their locations
unauthorized_keys=()

# Iterate over the authorized_keys files for all users
for path in "${authorized_keys_paths[@]}"; do
  # Expand the glob pattern to find authorized_keys files
  files=( $path )

  for file in "${files[@]}"; do
    # Extract the username from the file path
    if [[ $file =~ /([^/]+)/\.ssh/authorized_keys$ ]]; then
      username=${BASH_REMATCH[1]}

      # Check if the authorized_keys file exists and is not empty
      if [[ -e "$file" && -s "$file" ]]; then
        # Read the contents of the authorized_keys file
        while IFS= read -r line; do

          # Check if the line is not a comment and contains an SSH key
          if [[ $line != "#"* && $line != "" ]]; then
            # Check if the key is authorized for the user
            if [[ -n "${authorized_users[$line]}" ]]; then
              continue
            fi

            unauthorized_keys+=("$line in $file")
          fi
        done < "$file"
      fi
    fi
  done
done

# Check if any unauthorized keys were found
if [[ ${#unauthorized_keys[@]} -gt 0 ]]; then
  echo "ALERT: Unauthorized SSH key entries found in authorized_keys files for the following users:"
  for key in "${unauthorized_keys[@]}"; do
    echo "- $key"
  done
else
  echo "SUCCESS: No unauthorized SSH key entries found in authorized_keys files for any users."
fi