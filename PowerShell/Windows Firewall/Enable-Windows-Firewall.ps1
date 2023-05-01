<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    Detect the state of the Windows firewall for all profiles, and if the 
    firewall is disabled, enable it.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
    https://raw.githubusercontent.com/levelsoftware/scripts/main/PowerShell/Windows%20Firewall/Enable-Windows-Firewall.ps1
#>

#Initialize
$profileName = $null
$profileStatus = $null
$i = 0

#Get the current Windows firewall settings for all profiles (Domain, Private, Public)
$profileName += get-netfirewallprofile | Select -ExpandProperty name
$profileStatus += get-netfirewallprofile | Select -ExpandProperty enabled

#List the status of each profile
foreach ($profileStatusItem in $profileStatus) {
    if ($profileStatusItem) {
        Write-host -foregroundcolor green $profileName[$i] "Profile: ENABLED"
    }
    else {
        Write-host -foregroundcolor red $profileName[$i] "Profile: DISABLED" 
    }
    $i++
}

#Enable the Windows firewall for profiles that have it disabled
if ($profileStatus -contains $false) {
    $i = 0
    foreach ($profileStatusItem in $profileStatus) {
        if ($profileStatusItem) {
        }
        else {
            Set-NetFirewallProfile -Profile $profileName[$i] -Enabled True
            Write-host -foregroundcolor green $profileName[$i] "profile firewall has been enabled!" 
        }
        $i++
    }
}
else {
    Write-Host "Firewall is already enabled on all profiles.  Exiting."
}
