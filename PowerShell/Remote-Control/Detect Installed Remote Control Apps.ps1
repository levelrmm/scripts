<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Pull the list of installed apps and filter on a list of known remote
    control tools.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

$RemoteAccessApps = $null

#List of remote access applications that will be searched for
$RemoteAccessApps = @"
Action1
AeroAdmin
AirDroid
Alpemix
Ammyy
AnyDesk
Anyplace
Atera
AweSun
Bomgar
Chrome Remote Desktop
ConnectWise Automate
ConnectWise Control
Connectwise RMM
Continuum
CrazyRemote
DameWare
Datto RMM
DeskShare
Ericom AccessNow
FastViewer
FixMe.IT
GetScreen
GoToAssist
GoToMyPC
Goverlan
Guacamole
Honeywell TotalConnect
HopToDesk
ISL Light
Impero
Itarian
JSP File Browser
Jump Client
Jump Desktop
Kaseya
Labtech
LiveCare
LogMeIn
MSP360 Remote Assistant
ManageEngine
Millennium Remote Support
MoboRobo
Motorola Timbuktu
N-Able
N-Sight
N-central
NTR Support
Naverisk
NetSupport
Netop
NinjaOne
NinjaRMM
NoMachine
OptiTune
Panorama9
Parsec
pcAnywhere
PhoneMyPc
Pocket Controller
Pulseway
RDM+
RMS Connect
Radmin
Remote Assist
Remote Desktop
Remote GDB
Remote Utilities
RemotePC
Remotely
Remotix
Rexec
Rlogin
Rsupport
RustDesk
SOTI XSight
ScreenConnect
Screenhero
ShowMyPC
Splashtop
SpyAgent
Sunlogin
SuperOps
Supremo
Syncro
Synergy
Take Control
TeamViewer
UltraViewer
VNC
Webex Support
Windows Agent
Yoics
Zoho Assist
"@ -split "`n" | ForEach-Object { $_.trim() }

#Convert the array into a piped list so we can easily use it for a -match filter
$RemoteAccessApps = (($RemoteAccessApps | ForEach-Object { [regex]::Escape($_) }) -join "|")

#Get the list of installed apps -- filtering for items in our list.
$ErrorActionPreference = "silentlycontinue"
get-package | Where-Object Name -match "$RemoteAccessApps" | Select -ExpandProperty Name