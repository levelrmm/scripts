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
# Name: Linux Monitor - Ping
# Description: This script performs a series of 30 pings to a host and displays
# an error message if a series of consecutive pings fail.
# Language: Bash
# Timeout: 30
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - Ping
# Script output: Contains
# Output value: ERROR
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - host_to_ping
# - ping_count
# - consecutive_failures_threshold

host_to_ping="google.com"
ping_count=30
consecutive_failures_threshold=3

# -----------------------------------------------------------------------------

failed_pings=0
consecutive_failures=0

for ((i=1; i<=ping_count; i++)); do
  ping_result=$(ping -c 1 "$host_to_ping" 2>&1)

  if [ $? -ne 0 ]; then
    echo -e "Ping $i: FAILED\n"
    echo "Ping output: $ping_result"
    failed_pings=$((failed_pings + 1))
    consecutive_failures=$((consecutive_failures + 1))
  else
    echo "Ping $i: SUCCESS"
    consecutive_failures=0
  fi

  if [ $consecutive_failures -ge $consecutive_failures_threshold ]; then
    break
  fi
done

if [ $consecutive_failures -ge $consecutive_failures_threshold ]; then
  echo -e "\nERROR: $consecutive_failures_threshold consecutive pings to $host_to_ping failed\n"
elif [ $failed_pings -gt 0 ]; then
  echo -e "\nWARNING: $failed_pings out of $ping_count pings to $host_to_ping failed\n"
else
  echo -e "\nSUCCESS: All $ping_count pings to $host_to_ping were successful\n"
fi
