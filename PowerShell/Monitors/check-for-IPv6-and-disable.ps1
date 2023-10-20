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
# Name: Windows Monitor - Check for IPv6 and disable
# Description: This script checks if IPv6 is enabled on each NIC, and if it is
# then IPv6 is disabled on each.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Check for IPv6 and disable
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 24
# -----------------------------------------------------------------------------

# Get all network adapters with IPv6 enabled
$adaptersWithIPv6 = Get-NetAdapterBinding -ComponentID ms_tcpip6 | Where-Object { $_.Enabled -eq $true }

# Loop through each adapter and disable IPv6 if it's enabled
foreach ($adapter in $adaptersWithIPv6) {
    try {
        Write-Host "Attempting to disable IPv6 on $($adapter.Name)..."
        Disable-NetAdapterBinding -Name $adapter.Name -ComponentID ms_tcpip6 -ErrorAction Stop
        Write-Host "IPv6 disabled on $($adapter.Name).`n"
    } catch {
        Write-Host "ALERT: Error disabling IPv6 on $($adapter.Name): $_"
        exit 1
    }
}

Write-Host "Script completed successfully."