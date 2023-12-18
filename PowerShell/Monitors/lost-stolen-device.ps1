<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment. We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    This script is designed to protect data on a stolen laptop by wiping sensitive information.
    It covers system details, networking info, browser data, email clients, authentication credentials, 
    and other potentially sensitive data stored on the device.

    WARNING: This script will permanently delete data. Use with extreme caution.
    
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

# WARNING: Dangerous operation - Recursively delete files and directories for all users
# Uncomment the line below to enable this operation. Make sure you understand the risks!
# Get-ChildItem -Path "C:\Users" -Recurse | Remove-Item -Force -Recurse

# Clear Browser Data (Example for Chrome, modify for other browsers as needed)
# Remove-Item "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\*" -Recurse -Force

# Clear Outlook Data (Modify the path if different)
# Remove-Item "$env:APPDATA\Microsoft\Outlook\*" -Recurse -Force

# Remove VPN Credentials (Example for a specific VPN client, modify as needed)
# Remove-Item "Path\To\VPN\Credentials\Store" -Force

# Remove Saved Wi-Fi Networks
netsh wlan delete profile name="*"

# Remove Windows Credentials
cmdkey /list | ForEach-Object {if ($_ -like "*Target:*") {cmdkey /delete:($_ -replace " ","" -replace "Target:","")}}

# WARNING: Following actions are to be performed with extreme caution
# Uncomment the below sections only if you are sure about the implications

# Remove SSH Keys (if applicable)
# Remove-Item "$env:USERPROFILE\.ssh\*" -Force -Recurse

# End of Script
