<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Checks local disk health
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

# Checks local disks for health status
$DiskState = Get-PhysicalDisk | Where-Object {$_.HealthStatus  -ne 'Healthy'}
if ($DiskState){
    write-host "Alert!"
    exit
}