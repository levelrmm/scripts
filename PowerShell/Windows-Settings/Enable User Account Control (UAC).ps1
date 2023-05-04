<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
    List the current UAC settings and then change them to defaults and list
    again.
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

#Setup
$path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$filter = "ConsentPromptBehaviorAdmin|ConsentPromptBehaviorUser|EnableInstallerDetection|EnableLUA|EnableVirtualization|PromptOnSecureDesktop|ValidateAdminCodeSignatures|FilterAdministratorToken"

#List current UAC settings
Write-Host "Old UAC settings:"
(Get-ItemProperty $path).psobject.properties | where { $_.name -match $filter } | select name, value | Sort-Object name

#Set UAC to the default setting of "Notify me only when apps try to make changes to my computer (default)"
New-ItemProperty -Path $path -Name 'ConsentPromptBehaviorAdmin' -Value 5 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $path -Name 'ConsentPromptBehaviorUser' -Value 3 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $path -Name 'EnableInstallerDetection' -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $path -Name 'EnableLUA' -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $path -Name 'EnableVirtualization' -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $path -Name 'PromptOnSecureDesktop' -Value 1 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $path -Name 'ValidateAdminCodeSignatures' -Value 0 -PropertyType DWORD -Force | Out-Null
New-ItemProperty -Path $path -Name 'FilterAdministratorToken' -Value 0 -PropertyType DWORD -Force | Out-Null

#List the newly edited UAC values
Write-Host "`n`n`nNew UAC settings:"
(Get-ItemProperty $path).psobject.properties | where { $_.name -match $filter } | select name, value | Sort-Object name

#Need to reboot before these take effect
Write-Host "`nSettings will not be applied until the computer is rebooted."