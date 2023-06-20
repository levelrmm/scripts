<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Check if Bitlocker is enabled.  Only check local disks and ignores USB drives
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>


#Check for Bitlocker status
$BitlockerStatus = Get-Disk | Where-Object { $_.bustype -ne 'USB' } | Get-Partition | Where-Object { $_.DriveLetter } | Select-Object -ExpandProperty DriveLetter | Get-BitLockerVolume | where ProtectionStatus -eq Off

if ($BitlockerStatus) {
    Write-host "Alert!"
}