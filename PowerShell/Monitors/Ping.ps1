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
# Name: Windows Monitor - Ping
# Description: This script performs a series of 30 pings to a host and displays
# an error message if a series of consecutive pings fail.
# Language: PowerShell
# Timeout: 30
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Windows Monitor - Ping
# Script output: Contains
# Output value: ERROR
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE
# - host_to_ping
# - ping_count
# - consecutive_failures_threshold

$host_to_ping = "google.com"
$ping_count = 30
$consecutive_failures_threshold = 3

# -----------------------------------------------------------------------------

$failed_pings = 0
$consecutive_failures = 0

for ($i = 1; $i -le $ping_count; $i++) {
  $ping_result = Test-Connection -ComputerName $host_to_ping -Count 1 -Quiet

  if (-not $ping_result) {
    Write-Host ("Ping " + $i + ": FAILED")
    $failed_pings++
    $consecutive_failures++

    # Additional ping output information can be obtained using the Test-Connection cmdlet if needed
    # Write-Host "Ping output: $($ping_result | Out-String)"
  }
  else {
    Write-Host ("Ping " + $i + ": SUCCESS")
    $consecutive_failures = 0
  }

  if ($consecutive_failures -ge $consecutive_failures_threshold) {
    break
  }
}

if ($consecutive_failures -ge $consecutive_failures_threshold) {
  Write-Host ("`nERROR: " + $consecutive_failures_threshold + " consecutive pings to " + $host_to_ping + " failed")
}
elseif ($failed_pings -gt 0) {
  Write-Host ("`nWARNING: " + $failed_pings + " out of " + $ping_count + " pings to " + $host_to_ping + " failed")
}
else {
  Write-Host ("`nSUCCESS: All " + $ping_count + " pings to " + $host_to_ping + " were successful")
}