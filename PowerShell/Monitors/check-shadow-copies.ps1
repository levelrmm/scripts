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

# Run vssadmin to list all the shadow copies present
$vssShadows = vssadmin list shadows
# Create a custom object to store the latest shadow copy creation time for each drive
$latestShadowCopies = @()
$currentDriveLetter = $null
$currentCreationTime = $null

# Iterate through the vssadmin output to extract drive letters and creation times
foreach ($line in $vssShadows) {
    # Regex to parse the vssadmin output for drive letters
    if ($line -match 'Original Volume: \((\w):') {
        $currentDriveLetter = $matches[1]
    }
    # Regex to parse the vssadmin output for snapshot creation times
    elseif ($line -match 'Creation time: (.*)') {
        $currentCreationTime = Get-Date $matches[1]
        if ($currentDriveLetter -ne $null -and $currentCreationTime -ne $null) {
            # Check if this shadow copy is newer than the stored one
            $existingCopy = $latestShadowCopies | Where-Object { $_.DriveLetter -eq $currentDriveLetter }

            if ($existingCopy -eq $null) {
                # Create a new custom object to store drive letter and creation time
                $latestShadowCopy = [PSCustomObject]@{
                    DriveLetter  = $currentDriveLetter
                    CreationTime = $currentCreationTime
                }
                $latestShadowCopies += $latestShadowCopy
            }
            else {
                # Update the stored creation time if a newer shadow copy is found
                if ($existingCopy.CreationTime -lt $currentCreationTime) {
                    $existingCopy.CreationTime = $currentCreationTime
                }
            }

            $currentDriveLetter = $null
            $currentCreationTime = $null
        }
    }
}

# List all the known volumes and filter on volumes with drive letters using NTFS
$knownDriveLetters = Get-Volume | Where-Object { $_.DriveLetter -ne $null -and $_.FileSystemType -EQ 'NTFS' } | Select-Object -ExpandProperty DriveLetter

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