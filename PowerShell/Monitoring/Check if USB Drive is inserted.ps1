<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Check if USB Drive is present
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>


#Look for USB Drives
$USBDrivePresent = Get-CimInstance -ClassName Win32_DiskDrive | where { $_.InterfaceType -eq 'USB' }

if ($USBDrivePresent) {
    #If threshold breached send console message for Level to alert on
    Write-Host "Alert!"
}