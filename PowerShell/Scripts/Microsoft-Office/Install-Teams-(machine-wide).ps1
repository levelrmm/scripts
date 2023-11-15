# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment.  We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Install Teams Machine-Wide
# Description: Download Teams from Microsoft.com and install it. Using the 
# machine-wide MSI installation method
#
# Language: PowerShell
# Timeout: 300
# Version: 1.0
#

$TempFolder = 'C:\temp\'
if (Test-Path -Path $TempFolder -ErrorAction SilentlyContinue) {
}
else {
    mkdir $TempFolder
}

# Download the Teams installer from Microsoft.com
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'
$DownloadURL = "https://teams.microsoft.com/downloads/desktopurl?env=production&plat=windows&arch=x64&managedInstaller=true&download=true"
$File = "Teams_windows_x64.msi"
Invoke-WebRequest -uri $DownloadURL -outfile $TempFolder$File -UseBasicParsing
$FileSize = [math]::round((Get-Item -Path $TempFolder$File).Length / 1MB, 2)
"Downloaded $File - $FileSize MB"

# Install Teams
& msiexec /i $TempFolder$File /qn ALLUSERS=1