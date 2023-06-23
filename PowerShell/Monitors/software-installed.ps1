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
# Name: Software Check
# Description: This script checks if a specific software is installed.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Software Check
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - software_name
# - expected_version (optional)

# Name of the software to check
$software_name = "Your Software Name"

# Expected version of the software (optional)
$expected_version = "X.X.X"

# -----------------------------------------------------------------------------

# Function to check if the software is installed
function Check-Software {
    param (
        [string]$SoftwareName,
        [string]$ExpectedVersion
    )

    $installed_version = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq $SoftwareName } | Select-Object -ExpandProperty Version

    if ($installed_version -eq $null) {
        Write-Host "ALERT: $SoftwareName is not installed"
        exit 1
    }
    elseif ($ExpectedVersion -and $installed_version -ne $ExpectedVersion) {
        Write-Host "ALERT: $SoftwareName version mismatch"
        Write-Host "Installed version: $installed_version"
        Write-Host "Expected version: $ExpectedVersion"
        exit 1
    }
    else {
        Write-Host "SUCCESS: $SoftwareName is installed"
    }
}

# Check if the software is installed
Check-Software -SoftwareName $software_name -ExpectedVersion $expected_version
