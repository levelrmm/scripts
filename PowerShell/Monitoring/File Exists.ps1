# -----------------------------------------------------------------------------
# This script is provided as a convenience. Please test before deploying to
# your production environment.
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - File Exists
# Description: This recurring script checks for the existence of a specific file.
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - File Exists
# Script output: Contains
# Output value: "file exists" or "not found"
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - file_path

# Specify the file path to check for existence
$file_path = "/path/to/file.txt"
# -----------------------------------------------------------------------------

# Check if the file exists
if (Test-Path -Path $file_path) {
    Write-Host "file exists: $file_path"
}
else {
    Write-Host "file not found: $file_path"
}
