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
# Name: Linux Monitor - Open Ports
# Description: This script lists open/listening ports on a device and checks for 
# unauthorized ports. Requires netstat to be installed.
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - Open Ports
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - authorized_ports

# Authorized ports
authorized_ports=("53" "80" "443" "4242" "9100" "9292" "9393" "3000")  # Add or remove ports as needed
# -----------------------------------------------------------------------------

# Get the list of open/listening ports
open_ports=$(netstat -tuln | awk '/^tcp/ {print $4}' | awk -F ":" '{print $NF}')

# Variables to track the number of unauthorized ports found
unauthorized_count=0
unauthorized_ports=""

# Iterate over the open ports
for port in ${open_ports[@]}; do
  if [[ ! " ${authorized_ports[@]} " =~ " ${port} " ]]; then
    echo -e "ALERT: Unauthorized port ($port) is in use\n"
    unauthorized_count=$((unauthorized_count + 1))
    unauthorized_ports+=" $port"
  fi
done

# Check if any unauthorized ports were found
if [ $unauthorized_count -gt 0 ]; then
  echo -e "ALERT: $unauthorized_count unauthorized ports found\n"
  echo "Unauthorized ports in use: $unauthorized_ports"
else
  echo "SUCCESS"
fi
