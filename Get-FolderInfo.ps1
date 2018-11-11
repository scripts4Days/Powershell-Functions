Function Get-FolderInfo
{
<#
.Synopsis
   Get the number of files in a folder and it's size

.DESCRIPTION
   Calulates the totoal number of files located in the folder. Also,
   get the total size of the folder in bytes. This function uses 
   robocopy to gather the info which makes it faster than using
   Get-ChildItem.

.Parameter Path
   Path of the folder your want to measure

.EXAMPLE
   $folder = Get-FolderInfo -Path "C:\Users\User1"

.INPUTS
   String

.OUTPUTS
   PsCustomObject
.NOTES
    Author: Matt Hussey
#>
    Param
    (
        [Parameter(Mandatory = $true,
                   ValueFromPipeline = $true,
                   ValueFromPipelineByPropertyName = $true)]
        [String]$Path
    )

    Process
    {
        $output = robocopy $Path NULL /L /S /NJH /BYTES /FP /NC /NDL /TS /XJ /R:0 /W:0
        
        if ($output[-5] -match "^\s{3}Files\s:\s+(?<Count>\d+).*") { $count = $matches.Count }
    
        if ($count -gt 0) 
        { 
            If ($output[-4] -match "^\s{3}Bytes\s:\s+(?<Size>\d+(?:\.?\d+)).*") { $bytes = $matches.Size } 
        } 
        else { $bytes = 0 }

        return [pscustomobject]@{ "Count" = $count; "Size" = $bytes }
    }
}