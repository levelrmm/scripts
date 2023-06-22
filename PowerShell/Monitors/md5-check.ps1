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
# Name: Windows Monitor - MD5 Check
# Description: This script compares the MD5 hash of a file with a supplied hash.
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - MD5 Check
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
$filePath = "C:\path\to\file"
$suppliedHash = ""

# -----------------------------------------------------------------------------

# Check if the file exists
if (-not (Test-Path -Path $filePath -PathType Leaf)) {
    Write-Error "ALERT: File does not exist: $filePath"
    exit 1
}

# Calculate the MD5 hash of the file
$hashAlgorithm = [System.Security.Cryptography.MD5]::Create()
$hashStream = [System.IO.File]::OpenRead($filePath)
$calculatedHash = [System.BitConverter]::ToString($hashAlgorithm.ComputeHash($hashStream)).Replace("-", "")
$hashStream.Close()

# Compare the calculated hash with the supplied hash
if ($calculatedHash -eq $suppliedHash) {
    Write-Output "SUCCESS: The MD5 hash of $filePath matches the supplied hash."
}
else {
    Write-Output "ALERT: The MD5 hash of $filePath does not match the supplied hash."
    Write-Output "Expected hash: $suppliedHash"
    Write-Output "Calculated hash: $calculatedHash"
}
