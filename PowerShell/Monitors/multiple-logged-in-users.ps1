# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Check Multiple User Sessions
# Description: This script checks if more than one user is logged into the system and alerts if so.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------
# Monitor Configuration
# -----------------------------------------------------------------------------
# Script: Check Multiple User Sessions
# Script output: Contains
# Output value: ALERT
# Run frequency: Minutes
# Duration: 5
# -----------------------------------------------------------------------------

# Function to check for multiple user sessions
function Check-MultipleUserSessions {
    $userList = @()
    $userSessions = query user 2>&1 | Select-Object -Skip 1

    foreach ($session in $userSessions) {
        $sessionInfo = $session -split "\s+" | Where-Object { $_ }
        if ($sessionInfo) {
            $userList += $sessionInfo[1]
        }
    }

    $activeSessions = $userList.Count

    Write-Host "Number of active user sessions: $activeSessions"

    if ($activeSessions -gt 1) {
        Write-Host "ALERT: More than one user session is active."
        exit 1
    }
}

# Run the function to check for multiple user sessions
Check-MultipleUserSessions
