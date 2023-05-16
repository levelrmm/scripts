<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Detect the primary IP address of the device and perform a network scan
    looking for TCP ports 22,23,80,443,3389.  Also perform name lookup and
    pull the manufacturer from the MAC address.

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Check for NuGet on the device and install if not present
if (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue) {
    #Write-Host "NuGet Package already exists"
}
else {
    Write-host "Installing NuGet"
    Install-PackageProvider -Name NuGet -force
}   

#Check for dependent modules and install if not present
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
$ModuleList = "AdminToolbox.Networking"
foreach ($Module in $ModuleList) {
    if (Get-Module -ListAvailable -Name $Module -ErrorAction SilentlyContinue) {
        #Write-Host "$Module module already exists"
    } 
    else {
        Write-Host "$Module does not exist. Installing"
        Install-Module -Name $Module -Force -AllowClobber
    }
}

#Get the primary IP address of the device and put it in CIDR notation
$PrimaryIP = Find-NetRoute -RemoteIPAddress 0.0.0.0 | select *IPAddress*, *PrefixLength*
[string]$IP = $PrimaryIP.IPAddress
[string]$mask = $PrimaryIP.PrefixLength
$IP = $IP.trim()
$mask = $mask.Trim()

#Check if the subnet mask is too large to scan in a reasonable time
if ($mask -le 21) {
    Write-Host "This /$mask network is too large to scan in a timely manner!"
    exit 1
}
$IPandMask = $IP + "/" + $mask

Write-Host "Beginning network scan. This may take a few minutes depending on the size of the network."

#Start the network scan and format the table for good readability
Invoke-NetworkScan -CIDR $IPandMask  | Format-Table -Property `
@{Name = "IP"; expression = 'IP'; Width = 15 }, `
@{Name = "Hostname"; expression = 'Hostname'; Width = 30 }, `
@{Name = "Ping"; expression = { $_.Ping -replace "False$", "-" }; Width = 4 }, `
@{Name = "SSH"; expression = { $_.'ssh(22)' -replace "False$", "-" }; Width = 4 }, `
@{Name = "Telnet"; expression = { $_.'telnet(23)' -replace "False$", "-" }; Width = 6 }, `
@{Name = "HTTP"; expression = { $_.'http(80)' -replace "False$", "-" }; Width = 4 }, `
@{Name = "HTTPS"; expression = { $_.'https(443)' -replace "False$", "-" }; Width = 5 }, `
@{Name = "RDP"; expression = { $_.'rdp(3389)' -replace "False$", "-" }; Width = 4; Align = "center" }, `
@{Name = "Mac Address"; expression = 'MacAddress'; Width = 17 }, `
@{Name = "Vendor"; expression = { $_.vendor -replace '(.+?)(?:~|,).+', '$1' }; Width = 22 } -wrap

