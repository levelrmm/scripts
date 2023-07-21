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
# Name: Linux Monitor - Backup Presense Check
# Description: This script checks for multiple daily backups.
# Language: Bash
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Linux Monitor - Backup Presense Check
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 14
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - backup_dir
# - expected_backups

# Define backup directory
backup_dir="/path/to/backup/directory"

# Define expected number of backups
expected_backups=2
# -----------------------------------------------------------------------------

# Define today's date
today=$(date '+%Y_%m_%d')

# Count number of files modified today
num_backups=$(find $backup_dir -type f -mtime 0 | wc -l)

# Check if expected_backups count exist for today
if [ $num_backups -eq $expected_backups ]; then
  echo "All backups for today are present. Good job!"
else
  echo "ALERT: Expected $expected_backups backups for today, but found $num_backups. Please investigate!"
fi
