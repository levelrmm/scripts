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
# Name: Windows Monitor - Reboot Check
# Description: This script checks to see if reboot is required.
# Language: PowerShell
# Timeout: 30
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Reboot Check
# Script output: Contains
# Output value: ALERT
# Run frequency: Hour
# Duration: 1
# -----------------------------------------------------------------------------

$UpdateSession = New-Object -ComObject Microsoft.Update.Session
$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
$SearchResult = $UpdateSearcher.Search("IsInstalled=0 and Type='Software' and IsHidden=0")

if ($SearchResult.Updates.Count -gt 0) {
    Write-Output "ALERT: Reboot Required"
} else {
    Write-Output "No reboot is required."
}
