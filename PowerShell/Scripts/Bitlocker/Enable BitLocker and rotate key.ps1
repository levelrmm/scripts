# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Enable/Rotate bitlocker
# Description: Enables BitLocker and rotates the key.
# Language: PowerShell
# Timeout: 300
# Version: 1.0
# -----------------------------------------------------------------------------

# Check if BitLocker is enabled
$bitlockerStatus = (Get-BitLockerVolume -MountPoint "C:").ProtectionStatus

if ($bitlockerStatus -eq "Off") {
    try {
        # Enable BitLocker with TPM and generate recovery key
        Enable-BitLocker -MountPoint "C:" -UsedSpaceOnly -SkipHardwareTest -RecoveryPasswordProtector -TpmProtector
        
        # Get and verify the new recovery key
        $recoveryKey = (Get-BitLockerVolume -MountPoint "C:").KeyProtector | 
            Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"} | 
            Select-Object -ExpandProperty RecoveryPassword

        if (-not $recoveryKey) {
            Write-Output "ERROR: Failed to get recovery key after enabling BitLocker"
            exit 1
        }
    } catch {
        Write-Output "ERROR: Failed to enable BitLocker: $_"
        exit 1
    }
} else {
    try {
        # Get current recovery key(s)
        $oldKeys = (Get-BitLockerVolume -MountPoint "C:").KeyProtector | 
            Where-Object {$_.KeyProtectorType -eq "RecoveryPassword"}
        
        if ($oldKeys.Count -eq 0) {
            Write-Output "ERROR: No existing recovery keys found"
            exit 1
        }

        # Generate new recovery key
        $newKey = Add-BitLockerKeyProtector -MountPoint "C:" -RecoveryPasswordProtector

        # Get and verify new recovery key
        $recoveryKey = (Get-BitLockerVolume -MountPoint "C:").KeyProtector | 
            Where-Object {$_.KeyProtectorType -eq "RecoveryPassword" -and $_.KeyProtectorId -eq $newKey.KeyProtectorId} | 
            Select-Object -ExpandProperty RecoveryPassword

        if (-not $recoveryKey) {
            Write-Output "ERROR: Failed to add new recovery key"
            exit 1
        }

        # Remove old keys
        foreach ($oldKey in $oldKeys) {
            Remove-BitLockerKeyProtector -MountPoint "C:" -KeyProtectorId $oldKey.KeyProtectorId
        }
    } catch {
        Write-Output "ERROR: Failed to rotate BitLocker key: $_"
        exit 1
    }
}

# Output the recovery key (either new or rotated)
Write-Output $recoveryKey
