<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Add Windows Defender exclusions for Level.io
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

Add-MpPreference -ExclusionPath “C:\Program Files\Level" -Force
Add-MpPreference -ExclusionProcess "Level.exe" -Force