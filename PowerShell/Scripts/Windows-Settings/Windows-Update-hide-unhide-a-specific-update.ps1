# -----------------------------------------------------------------------------
# This script is provided as a convenience for Level.io customers. We cannot 
# guarantee this will work in all environments. Please test before deploying
# to your production environment. We welcome contribution to the scripts in 
# our community repo!
#
# -----------------------------------------------------------------------------
# Script Configuration
# -----------------------------------------------------------------------------
# Name: Windows Update - Hide/Unhide Specific Update
# Description: Hide or unhide the specific update specified
# 
# Language: PowerShell
# Timeout: 180
# Version: 1.0
#
# -----------------------------------------------------------------------------

# Define variables for KB number or Title and the action (Hide/Unhide)
# Use the complete update title.  Or use a KB number with wildcards around it "*KB5029263*"
$kbNumberOrTitleToModify = "*KB5029263*"

# Set to $true to hide the update, or $false to unhide it
$hideUpdate = $true  

# Create a COM object for Microsoft.Update.Session
$session = New-Object -ComObject "Microsoft.Update.Session"
$searcher = $session.CreateUpdateSearcher()

# Get a list of installed updates using GetTotalHistoryCount()
$historyCount = $searcher.GetTotalHistoryCount()
Write-Host "Checking $historyCount installed updates for a match ..."
$historyUpdates = $searcher.QueryHistory(0, $historyCount)

# Find the update in installed updates and exit if found
foreach ($update in $historyUpdates) {
    if ($update.Title -like $kbNumberOrTitleToModify) {
        Write-Host "ALERT - The matched update ""$($update.Title)"" is already installed. No action required."
        exit 1
    }
}

$updateToModify = $null

# Get the list of pending updates
$pendingUpdates = $searcher.Search('IsInstalled=0').Updates
Write-Host "Checking $($pendingUpdates.count) pending updates for a match ..."

# Find the update by KB number or Title and perform the action
foreach ($update in $pendingUpdates) {
    if ($update.Title -like $kbNumberOrTitleToModify) {
        $updateToModify = $update
        break  # Stop searching once we find a match
    }
}


if ($updateToModify -eq $null) {
    Write-Host "ALERT - Update with KB number or Title '$kbNumberOrTitleToModify' not found among installed or pending updates."
    exit 1
}
else {
    if ($hideUpdate) {
        # Hide the update
        Write-Host "Hiding update ""$($updateToModify.Title)""..."
        $updateToModify.IsHidden = $true
        $action = "hidden"
    }
    else {
        # Unhide the update (if applicable)
        Write-Host "Unhiding update ""$($updateToModify.Title)""..."
        $updateToModify.IsHidden = $false
        $action = "unhidden"
    }
    
    Write-Host "Success - ""$($updateToModify.Title)"" has been $action."
}