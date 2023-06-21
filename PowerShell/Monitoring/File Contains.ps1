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
# Name: Windows Monitor - File Contains
# Description: This script checks the contents of a file for a specific string.
# Language: PowerShell
# Timeout: 100
# Version: 1.0
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - File Contains
# Script output: Contains
# Output value: ERROR
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - file_path
# - search_string

# Specify the file path to check
$file_path = "C:\path\to\file.txt"

# Specify the string to search for in the file
$search_string = "example"
# -----------------------------------------------------------------------------

# Check if the file exists
if (Test-Path -Path $file_path) {
    $file_content = Get-Content -Path $file_path -Raw
    if ($file_content -like "*$search_string*") {
        Write-Host "SUCCESS: The string '$search_string' exists in the file."
    }
    else {
        Write-Host "ERROR: The string '$search_string' does not exist in the file."
    }
}
else {
    Write-Host "ERROR: File not found: $file_path"
}
