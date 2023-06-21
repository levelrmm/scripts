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
# Name: Linux Monitor - New Users
# Description: This recurring script checks for unexpected users in /etc/passwd 
# every 5 minutes, alerts only for non-excluded users, and displays an error 
# message with the list of unexpected users if any are found.
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - New Users
# Script output: Contains
# Output value: ERROR
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - default_users
# - other_users
# - service_users

# default_users to exclude
default_users=("root" "daemon" "bin" "sys" "sync" "games" "man" "lp" "mail" "news" "uucp" "proxy" "www-data" "backup" "list" "irc" "gnats" "nobody" "_apt" "systemd-network" "systemd-resolve" "messagebus" "systemd-timesync" "pollinate" "sshd" "syslog" "uuidd" "tcpdump" "tss" "landscape" "usbmux")

# other_users to exclude
other_users=("deploy")

# service_users to exclude
service_users=("nginx" "redis")
# -----------------------------------------------------------------------------

# Read the /etc/passwd file and extract the list of usernames
passwd_users=$(cut -d: -f1 /etc/passwd)

# Combine the default_users, other_users, and service_users arrays
exclude_users=("${default_users[@]}" "${other_users[@]}" "${service_users[@]}")

# Variables to track the number of unexpected users found
unexpected_count=0
unexpected_users=""

# Iterate over the passwd_users
for passwd_user in ${passwd_users[@]}; do
  if [[ ! " ${exclude_users[@]} " =~ " ${passwd_user} " ]]; then
    echo -e "ALERT: Unexpected user ($passwd_user) found in /etc/passwd\n"
    unexpected_count=$((unexpected_count + 1))
    unexpected_users+=" $passwd_user"
  fi
done

# Check if any unexpected users were found
if [ $unexpected_count -gt 0 ]; then
  echo -e "ERROR: $unexpected_count unexpected users found in /etc/passwd\n"
  echo "Unexpected users found in /etc/passwd: $unexpected_users"
else
  echo "SUCCESS"
fi
