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
# Name: Logout all user sessions
# Description: Logs out all users after sending a warning message to the
# desktop
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------

# Logout warning message that will be displayed to the end-user session(s)
$message = "Warning: You will be logged off in 3 minutes. Please save your work."

# Display the message on all user sessions
$quserOutput = quser | Select-Object -Skip 1
$quserOutput | ForEach-Object {
    $sessionId = $_.Substring(39, 7).Trim()
    $username = $_.Substring(0, 18).Trim()
    msg.exe /time:180 $sessionId $message
    Write-host "Logoff warning message sent to $username" | Out-Host
}

# Countdown to logoff in 30 second increments.
$timer = 120
do {
    Write-Host "$timer seconds left before logging out user(s)." | Out-Host
    Sleep 30
    $timer = $timer - 30
} while ($timer -gt 0)

# Logoff all users
$quserOutput | ForEach-Object {
    $sessionId = $_.Substring(39, 7).Trim()
    logoff $sessionId /V
}