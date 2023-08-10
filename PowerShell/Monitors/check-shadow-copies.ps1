# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Monitor - Check that Shadow Copies are running on each drive
# Description: 
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Check that Shadow Copies are running on each drive
# Script output: Contains
# Output value: ALERT
# Run frequency: Hours
# Duration: 8
# -----------------------------------------------------------------------------

# Specify the maximum allowed hours since the last shadow copy before alerting
$hoursSinceLastShadowCopy = 24

#Check for PowerShell v5+
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "This script requires PowerShell version 5 or higher"
    exit 1
}

# Run vssadmin to list all the shadow copies present
$vssShadows = vssadmin list shadows
# Create an array to store the latest shadow copies
$latestShadowCopies = @()
$currentDriveLetter = $null
$currentCreationTime = $null

# Check for PowerShell v5+
if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host "This script requires PowerShell version 5 or higher"
    exit 1
}

# Run vssadmin to list all the shadow copies present
$vssShadows = vssadmin list shadows
# Create a custom object list to store the latest shadow copy creation time for each drive
$latestShadowCopies = @()

$currentTime = $null
$currentDriveLetters = @()

# Iterate through the vssadmin output to extract drive letters and creation times
foreach ($line in $vssShadows) {
    # Regex to parse the vssadmin output for snapshot creation times
    if ($line -match 'Contained \d+ shadow copies at creation time: (.*)') {
        $currentTime = Get-Date $matches[1]
    }
    # Regex to parse the vssadmin output for drive letters
    elseif ($line -match 'Original Volume: \((\w):') {
        $currentDriveLetters = $currentDriveLetters + $matches[1]
    }
    elseif ($line -eq '') {
        if ($currentTime -ne $null) {
            # Update the custom object list with the latest creation time for each drive letter
            foreach ($driveLetter in $currentDriveLetters) {
                $existingCopyIndex = -1
                for ($i = 0; $i -lt $latestShadowCopies.Count; $i++) {
                    if ($latestShadowCopies[$i].DriveLetter -eq $driveLetter) {
                        $existingCopyIndex = $i
                        break
                    }
                }
                if ($existingCopyIndex -ne -1) {
                    if ($currentTime -gt $latestShadowCopies[$existingCopyIndex].CreationTime) {
                        $latestShadowCopies[$existingCopyIndex].CreationTime = $currentTime
                    }
                }
                else {
                    $latestShadowCopy = [PSCustomObject]@{
                        DriveLetter  = $driveLetter
                        CreationTime = $currentTime
                    }
                    $latestShadowCopies += $latestShadowCopy
                }
            }
        }
        $currentDriveLetters = @()
    }
}

# List all the known volumes and filter on volumes with drive letters using NTFS.  Server 2012 uses FileSystem, newer uses FileSystemType
$knownDriveLetters = Get-Volume | Where-Object { $_.DriveLetter -ne $null -and ($_.FileSystemType -EQ 'NTFS' -or $_.FileSystem -EQ 'NTFS') } | Select-Object -ExpandProperty DriveLetter

# Using the list of all known NTFS volumes, compare if there are shadow copies within the specified time period.
foreach ($knownDriveLetter in $knownDriveLetters) {
    $matchingDrive = $latestShadowCopies | Where-Object { $_.DriveLetter -eq $knownDriveLetter }
 
    if ($matchingDrive) {
        $shadowCreationTime = $matchingDrive.CreationTime
        $timeDifference = (Get-Date) - $shadowCreationTime
        $maxAllowedTimeDifference = [TimeSpan]::FromHours($hoursSinceLastShadowCopy)
        if ($timeDifference -lt $maxAllowedTimeDifference) {
            Write-Host "Drive $knownDriveLetter has a recent Shadow Copy from $shadowCreationTime."
        }
        else {
            Write-Host "ALERT: Drive $knownDriveLetter has a Shadow Copy, but it's not within $hoursSinceLastShadowCopy hours."
            exit 1
        }  
    }
    else {
        Write-Host "ALERT: No Shadow Copies found for drive $knownDriveLetter!"
        exit 1
    }
}