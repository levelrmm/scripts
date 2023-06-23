# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - Host File Changes
# Description: This script monitors for non-excluded entries in the host file
# and alerts if any modifications are detected.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Host File Changes
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - host_file_path
# - excluded_entries

# Path to the host file
$hostFilePath = "C:\Windows\System32\drivers\etc\hosts"

# Array of excluded entries (default: "127.0.0.1" and "::1")
$excludedEntries = @("127.0.0.1", "::1")

# -----------------------------------------------------------------------------

# Function to check for non-excluded entries in the host file
function Check-HostFileChanges {
    param (
        [string]$FilePath,
        [string[]]$ExcludedEntries
    )

    if (Test-Path -Path $FilePath) {
        $currentContent = Get-Content -Path $FilePath

        foreach ($line in $currentContent) {
            $entry = $line.Trim()

            # Skip empty lines and commented lines
            if (-not [string]::IsNullOrWhiteSpace($entry) -and $entry -notlike "#*") {
                $ipAddress = ($entry -split '\s+')[0]

                # Check if the entry is excluded
                if ($ExcludedEntries -notcontains $ipAddress) {
                    Write-Host "ALERT: Non-excluded entry detected in the host file: $entry"
                    exit 1
                }
            }
        }
    }
}

# Check for non-excluded entries in the host file
Check-HostFileChanges -FilePath $hostFilePath -ExcludedEntries $excludedEntries
