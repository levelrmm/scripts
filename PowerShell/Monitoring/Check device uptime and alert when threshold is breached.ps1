<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Check for uptime of the computer
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>


#Get uptime of device
$Uptime = (get-date) - (gcim Win32_OperatingSystem).LastBootUpTime | select -ExpandProperty TotalDays
#Round it to a whole number
$Uptime = [math]::Round($Uptime)

if ($Uptime -gt 45) {
    #If threshold breached send console message for Level to alert on
    Write-Host "Alert!"
}