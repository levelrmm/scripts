<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Pull device details and networking information to help identify the 
    device and its possible location.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

# Get System Details
systeminfo

# Get Local IP
ipconfig /all

# Get Remote IP
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
(iwr https://ip.level.io/json -UseBasicParsing).Content.Trim()

#Get list of all visible wireless networks
netsh wlan show networks mode=bssid

#Get ARP table
arp -a