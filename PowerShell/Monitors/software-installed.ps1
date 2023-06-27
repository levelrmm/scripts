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

# Name of the software to check. Partial names will be matched
$software_name = "Chrome"

# Expected version of the software (optional)
$expected_version = "114.0.5735.134"

# -----------------------------------------------------------------------------

# Function to check if the software is installed
function Check-Software {
    param (
        [string]$SoftwareName,
        [string]$ExpectedVersion
    )

    $installed_app = get-package | Where-Object -Property Name -Like "*$SoftwareName*" | Select -ExpandProperty Name
    $installed_version = get-package | Where-Object -Property Name -Like "*$SoftwareName*" | Select -ExpandProperty Version

    if ($installed_version -eq $null) {
        Write-Host "ALERT: $SoftwareName is not found in any installed applications"
        exit 1
    }
    elseif ($ExpectedVersion -and $installed_version -ne $ExpectedVersion) {
        Write-Host "ALERT: $installed_app version mismatch"
        Write-Host "Installed version: $installed_version"
        Write-Host "Expected version: $ExpectedVersion"
        exit 1
    }
    else {
        Write-Host "SUCCESS: $installed_app is installed"
    }
}

# Check if the software is installed
Check-Software -SoftwareName $software_name -ExpectedVersion $expected_version
