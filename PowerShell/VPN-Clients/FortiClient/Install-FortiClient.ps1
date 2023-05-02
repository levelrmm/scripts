<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Install Forticlient and add a VPN profile.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>


$ClientName = "INSERT_VPN_PROFILE_NAME_HERE"
$VPN_URL = "INSERT_VPN_FQDN_HERE" #FQDN or IP of VPN - if using a unique port append ":"" and the port number (:4443)

#Function to create FortiClient profile
function SetupForticlientProfile {
    if (Test-Path -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$ClientName") {  
        "$ClientName profile already exists."
    }
    else {
        "$ClientName profile does not exist.  Creating now."
        New-Item "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$ClientName"
        New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$ClientName" -Name 'Description' -Value "$ClientName VPN" -PropertyType String
        New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$ClientName" -Name 'Server' -Value "$VPN_URL" -PropertyType String
        New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$ClientName" -Name 'promptusername' -Value 1 -PropertyType DWord
    }
}

#Check if FortiClient is already installed
$FortiClientExecutable = "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"
if (Test-Path -Path $FortiClientExecutable) {
    Write-Host "$FortiClientExecutable exists."
    SetupForticlientProfile
    exit 1
}
else {
    Write-Host "$FortiClientExecutable not found.  Installing FortiClient."
}

#Check for temp folder location and create if not present
$TempFolder = 'c:\temp'
if (Test-Path -Path $TempFolder) {
}
else {
    mkdir $TempFolder
}

#Download Forticlient installer 
$Installer = "$TempFolder\FortiClientVPNSetup_7.2.0.0690_x64.exe"
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
iwr -uri https://github.com/levelsoftware/scripts/raw/main/PowerShell/VPN-Clients/FortiClient/FortiClientVPNSetup_7.2.0.0690_x64.exe -outfile $Installer
$FileSize = [math]::round((Get-Item -Path $Installer).Length / 1MB, 2)
"Downloaded $Installer - $FileSize MB"

#Install FortiClient
Start-Process $Installer -Wait -ArgumentList "/quiet /norestart" -PassThru

#Check if FortiClient is already installed
$FortiClientExecutable = "C:\Program Files\Fortinet\FortiClient\FortiClient.exe"
if ( Test-Path -Path $FortiClientExecutable) {
    Write-Host "Forticlient successfully installed, setting up $ClientName VPN profile"
    Start-Sleep -Seconds 5 #The profile setup was failing if run too soon, even though we're using Start-Process with "-wait"
    SetupForticlientProfile
    exit
}
else {
    Write-Host "Forticlient was not installed successfully."
    Exit 1
}