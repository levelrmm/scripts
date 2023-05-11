<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Get infor about printers
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

Get-Printer | select name, Drivername, portname