<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Install Axcient 360recover agent (Replibit). 
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Change the Axcient server address (IP) and password
$AxcientApplianceIP = "INSERT_IP_HERE" #Must be reachable from the device where the agent is being installed
$AxcientAppliancePassword "INSERT_PASSWORD_HERE"

#Check for temp folder location and create if not present
$TempFolder = 'c:\temp'
if (Test-Path -Path $TempFolder) {
}
else {
    mkdir $TempFolder
}

#Download the Axcient installer
$AxcientInstaller = "agentInstaller.msi"
$Installer = $TempFolder\$AxcientInstaller
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
iwr -useb https://github.com/levelsoftware/scripts/raw/main/PowerShell/Backup-Apps/Axcient/$AxcientInstaller -outfile $Installer
$FileSize = [math]::round((Get-Item -Path $Installer).Length / 1MB, 2)
"Downloaded $Installer - $FileSize MB"

#Install Axcient 360recover agent
& $TempFolder\$Installer /quiet SERVER=$AxcientApplianceIP PASSWORD=$AxcientAppliancePassword