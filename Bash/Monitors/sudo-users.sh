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
# Name: Linux Monitor - Sudo Users
# Description: This script identifies unexpected sudo users, excluding those in
# the excluded list. It alerts for any unexpected sudo users found and displays 
# an error message with the list of unexpected users if any are detected.
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - Sudo Users
# Script output: Contains
# Output value: ERROR
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - excluded_sudo_users

# Array of known sudo users to exclude from output
excluded_sudo_users=("root" "deploy")
# -----------------------------------------------------------------------------

# Read the sudoers file and extract the list of users with sudo permissions
sudoers_file="/etc/sudoers"
sudoers_users=$(grep -E '^[^#]*\s+\ALL=\(ALL:ALL\)\s+ALL$' "$sudoers_file" | awk '{print $1}')

# Read the sudo group and extract the list of users in the group
sudo_group_users=$(getent group sudo | cut -d: -f4 | tr ',' ' ')

# Combine the users from sudoers and sudo group
all_sudo_users=($sudoers_users $sudo_group_users)

# Deduplicate and sort the list of sudo users
unique_sudo_users=$(echo "${all_sudo_users[@]}" | tr ' ' '\n' | sort -u)

# Variables to track the number of unexpected sudo users found
unexpected_count=0
unexpected_users=""

# alert on unexpected sudo users
for user in ${unique_sudo_users[@]}; do
  if [[ ! " ${excluded_sudo_users[@]} " =~ " ${user} " ]]; then
    echo -e "ALERT: Unexpected sudo user found: $user\n"
    unexpected_count=$((unexpected_count + 1))
    unexpected_users+=" $user"
  fi
done

# Check if any unexpected users were found
if [ $unexpected_count -gt 0 ]; then
  echo -e "ERROR: $unexpected_count unexpected sudo users found\n"
  echo "Unexpected sudo users found: $unexpected_users"
else
  echo "SUCCESS"
fi
