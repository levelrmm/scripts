<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Only run on a domain controller. This script checks whether the 
    Recycle Bin feature is enabled for the current domain in Active 
    Directory and enable it if not.

.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>
 

# Get the Recycle Bin feature details
$recyclebin = get-adoptionalfeature "recycle bin feature"

# Get the current Forest Functional Level
$forestmode = (get-adforest).forestmode

# If the Recycle Bin is not enabled, enable it.
if (($recyclebin.enabledscopes).count -eq 0) {
    
    $ADDomain = Get-ADDomain | Select -ExpandProperty Forest
    $ADInfraMaster = Get-ADDomain | Select-Object InfrastructureMaster
    write-host "Recycle Bin is not enabled" -foregroundcolor "red"

    # Display the required and current Forest Functional Levels
    write-host "Required Forest Functional Level:" $recyclebin.requiredforestmode "`nCurrent Forest Functional Level:" $forestmode
    Write-Host "`nAttempting to enable AD Recycle Bin"

    #Enable the AD recyle bin
    Enable-ADOptionalFeature -Identity 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target $ADDomain -Server $ADInfraMaster.InfrastructureMaster -Confirm:$false
    
    Write-Host "AD Recycle Bin has been enabled for domain $($ADDomain)"
}
else {
	
    write-host "Recycle Bin is already enabled for these Domain Controllers:" -foregroundcolor "green"

    # Loop through each DC it is enabled on
    foreach ($scope in $recyclebin.enabledscopes) {
        $DC = ($scope -split ",")[1].substring(3)
        # Print the name of the DC to the screen
        if ($DC -ne "Configuration") {
            write-host ($scope -split ",")[1].substring(3)
        }
        
    }
}