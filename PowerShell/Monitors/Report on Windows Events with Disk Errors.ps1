<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Checks local disks for errors reported in event viewer within the last
     24 hours
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

# Checks local disks for errors reported in event viewer within the last 24 hours

$ErrorActionPreference = 'silentlycontinue'
$TimeSpan = (Get-Date) - (New-TimeSpan -Day 1)
if (Get-WinEvent -FilterHashtable @{LogName = 'system'; ID = '11', '9', '15', '52', '129', '7', '98'; Level = 2, 3; ProviderName = '*disk*', '*storsvc*', '*ntfs*'; StartTime = $TimeSpan } -MaxEvents 10 | Where-Object -Property Message -Match Volume*) {
    Write-Output "Alert!"
    exit 1
}
else {
    Write-Output "Disks are Healthy"
    exit 0
}