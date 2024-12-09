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
# Name: Windows - Disable/Delete Users
# Description: This script disables or deletes a comma seperated list of users.
#
# Language: PowerShell
# Timeout: 100
# Version: 1.0
#
# -----------------------------------------------------------------------------

# Script Variable: usersToDelete
$userArray = "{{usersToDelete}}" -split ',' | ForEach-Object { $_.Trim() }

foreach ($user in $userArray) {
    # Check if the user exists (assuming we're looking for local users by username)
    if (Get-LocalUser -Name $user -ErrorAction SilentlyContinue) {
        try {
            # Disable the user account
            Disable-LocalUser -Name $user
            Write-Output "User $user has been disabled."
            
            # Commented out: To delete instead of disable, uncomment the next line
            # Remove-LocalUser -Name $user
            # Write-Output "User $user has been deleted."
        }
        catch {
            # Use double quotes with escaping for the colon
            Write-Error "Failed to disable user $user`: $_"
        }
    } else {
        Write-Output "User $user does not exist."
    }
}
