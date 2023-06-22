# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - Check Bitlocker Status
# Description: Check if Bitlocker is enabled. Only check local disks and ignores
# USB drives
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Check Bitlocker Status
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 12
# -----------------------------------------------------------------------------

# Check for Bitlocker status
$BitlockerStatus = Get-Disk | Where-Object { $_.Bustype -ne 'USB' } | Get-Partition | Where-Object { $_.DriveLetter } | Select-Object -ExpandProperty DriveLetter | Get-BitLockerVolume | Where-Object ProtectionStatus -eq 'Off'

if ($BitlockerStatus) {
    Write-Host "ALERT"
}
