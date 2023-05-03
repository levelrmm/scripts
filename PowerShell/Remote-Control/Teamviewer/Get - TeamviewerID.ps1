<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!
.DESCRIPTION
    Pull teamviewer ID from the HOST
.LANGUAGE
    PowerShell
.TIMEOUT
    100
.LINK
#>

$TeamViewerVersionsNums = @('6', '7', '8', '9', '')
$RegPaths = @('HKLM:\SOFTWARE\TeamViewer', 'HKLM:\SOFTWARE\Wow6432Node\TeamViewer')
$Paths = @(foreach ($TeamViewerVersionsNum in $TeamViewerVersionsNums) {
        foreach ($RegPath in $RegPaths) {
            $RegPath + $TeamViewerVersionsNum
        }
    })

foreach ($Path in $Paths) {
    If (Test-Path $Path) {
        $GoodPath = $Path
    }
}

foreach ($FullPath in $GoodPath) {
    If ($null -ne (Get-Item -Path $FullPath).GetValue('ClientID')) {
        $TeamViewerID = (Get-Item -Path $FullPath).GetValue('ClientID')
        $ErrorActionPreference = 'silentlycontinue'

    }



}

Write-Output "Teamviewer ID: $($TeamViewerID)"
