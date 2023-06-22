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
# Name: Event Log Monitor
# Description: Scan event log for event IDs and if found trigger an alert
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Event Log Monitor
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

#Chose which event log to monitor: application, security, or system
$LogName = "application"
#Chose which event ID to monitor.
$ID = 1000
#Chose the severity level of the event. (Critical 1, Error 2, Warning 3, 
#Informational 4) Can be comma seperated list (don't use quotes)
$EventSeverity = 2
#Chose the provider name (source) of the event.
$ProviderName = "Application Error"
#Chose the timeframe (in minutes) in which to search.  Search the logs filtered 
#to the past X minutes.  This should be synced up with the monitor run 
#frequency.  If the frequency will be set to checking every 5 minutes, then the
#timeframe shouldn't exceed that.
$Timeframe = 5


$TimeSpan = (Get-Date) - (New-TimeSpan -Minutes $Timeframe)
$ErrorActionPreference = 'silentlycontinue'

#Pull the events and filter them
$EventTracker = Get-WinEvent -FilterHashtable @{
    LogName      = $LogName
    ID           = $ID
    Level        = $EventSeverity
    ProviderName = $ProviderName
    StartTime    = $TimeSpan
} -MaxEvents 10

#Display the events
$EventTracker

#If there are events that match, trigger the ALERT
if ($EventTracker) {
    Write-Output "ALERT"
    Exit 1
}
else {
    Write-Output "Events not found.  Check your filter variables if you are expecting a match."
    Exit 0
}
