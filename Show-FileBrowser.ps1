Function Show-FileBrowser
{
<#
.Synopsis
   Display a file browser window

.DESCRIPTION
   Display a file browser window that the user
   can navigate through and select a file. The scipt
   returns the full path of file selected. 

.Parameter FileType
   Choose what file type the window will show. Example: .docx

.Parameter Title
   The text that will show at the top of the window.

.Parameter InitialDirectory
   The directory that will show when the window first
   opens.

.EXAMPLE
   Show-FileBrowser -FileType .txt -Title "Select a text file" -InitialDirectory "\\server\share"

.OUTPUTS
   String
#>   
    [CmdletBinding()]
    Param
    (
        [Parameter(ParameterSetName = "File Type")]
        [ValidatePattern('\.\w')]
        [String]$FileType = 'Any',

        [String]$Title = "Select a file",

        [String]$InitialDirectory = "C:"
    )

    # Add required dot net assembly
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
        
    # Create variables for which file types to show
    If ($FileType -eq 'Any')
    {
        $type = "All files"
        $extension = "*.*"
    }
    Else
    {
        $type = $FileType.TrimStart(".")
        $extension = $FileType        
    }
    
    # Create form
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $InitialDirectory
    $OpenFileDialog.Title = $Title
    $OpenFileDialog.filter = "$type ($extension) | *$extension"

    # Make sure form is above all other windows
    $topMost = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }

    $OpenFileDialog.ShowDialog($topMost) | Out-Null

    if ($OpenFileDialog.FileName -eq "cancel") { return $null }
    else { return $OpenFileDialog.filename }
}