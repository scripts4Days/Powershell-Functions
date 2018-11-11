Function Show-FolderBrowser
{
    Param
    (
        [String]$Description = 'Select the folder path',
        
        [ValidateScript({ Test-Path -Path $_ })]
        [String]$InitialDirectory = 'C:'
    )

    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = $Description
    $folderBrowser.SelectedPath = $InitialDirectory

    $topMost = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }
    $FolderBrowser.ShowDialog($topMost) | Out-Null
    
    return $FolderBrowser.SelectedPath
}