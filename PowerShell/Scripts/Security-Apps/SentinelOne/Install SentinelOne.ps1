<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Install Sentinel One for Windows 64-bit
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Replace this with your SentinelOne Site Token.  This can be found in your SentinelOne portal under Settings -> Sites.
$SiteToken = "INSERT_S1_TOKEN_HERE"

#The Windows 64-Bit installer
$S1_File = "SentinelInstaller_windows_64bit_v23_2_3_358.msi"

#Setup
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#Check if the SetntinelOne Agent service is already present.
$servicename = "SentinelAgent"
if (Get-Service $servicename -ErrorAction SilentlyContinue) {
    Write-Host "$servicename exists. Exiting..."
    exit 1
}
else {
    Write-Host "$servicename not found.  Installing Sentinel One."
}

$TempFolder = 'C:\temp'
if (Test-Path -Path $TempFolder) {
}
else {
    mkdir c:\temp
}

#Installer path
$Installer = "$TempFolder\$S1_File"

#Set VSS size to 10% prior to installing SentinelOne
vssadmin Resize ShadowStorage /For=C: /On=C: /MaxSize=10%

#Download the installer
$ProgressPreference = 'SilentlyContinue'
iwr -uri https://github.com/levelrmm/scripts/raw/main/PowerShell/Scripts/Security-Apps/SentinelOne/$S1_File -outfile $Installer
$FileSize = [math]::round((Get-Item -Path $Installer).Length / 1MB, 2)
"Downloaded $Installer - $FileSize MB"

#Run the installer
& $Installer /q /norestart UI=false SITE_TOKEN="$SiteToken"
