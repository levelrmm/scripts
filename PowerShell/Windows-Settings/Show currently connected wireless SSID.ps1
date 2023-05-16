<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Show the currently connected wireless SSID
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

$WifiStatus = netsh wlan show interfaces
$WifiState = netsh wlan show interfaces | Select-String State

#Filter out the devices that do not have wifi enabled
if ($WifiStatus -eq "The Wireless AutoConfig Service (wlansvc) is not running.") {
	write-host "Wifi is not enabled on this device"
	exit 1
}
#Filter out devices that have wifi enabled but are not connected via wifi
elseif ($WifiState -like "*disconnected*") {
	write-host "Wifi is not connected on this device"
	exit 1
}
#Use " SSID " so as to avoid picking up BSSID as well
netsh wlan show interfaces | select-string " SSID "