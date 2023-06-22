<#
This script is provided as a convenience for Level.io customers. We cannot 
guarantee this will work in all environments. Please test before deploying
to your production environment.  We welcome contribution to the scripts in 
our community repo!

.DESCRIPTION
   Run two reports back to back.  First list directories and their sizes.
   Next show the top 25 largest files.
.LANGUAGE
    PowerShell
.TIMEOUT
    300
.LINK
#>

#Adjust to reflect the drive letter.  Subfolder path may also be added in the entire drive does not need to be examined
$Drive = "c:\"
$folderList = @()

#Report on folder sizes
$subfolders = Get-ChildItem $Drive -Directory | Sort-Object  
foreach ($folder in $subfolders) {

    $size = Get-ChildItem -Path $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum
    [decimal]$sizeInGB = "{0:N2}" -f ($size.Sum / 1GB)

    #Create a custom object to format the list
    $ResultItems = [PSCustomObject]@{
        FolderName = "$folder"
        'Size(GB)' = $sizeInGB
    }
    #Add the results to array $folderList
    $folderList += $ResultItems
}
$folderList | Sort-Object -Property 'Size(GB)' -Descending | Out-Default

#Report on top 25 largest files
Write-Host "Largest files on $Drive"
Get-ChildItem $Drive -recurse -ErrorAction SilentlyContinue -Force | sort -descending -property length | select -first 25 name, @{Name = "Gigabytes"; Expression = { [Math]::round($_.length / 1GB, 2) } }, directory