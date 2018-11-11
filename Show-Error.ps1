Function Show-Error($Error)
{
    # Add required dot net assemblies
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("PresentationFramework") | Out-Null
    
    # Error info that will be displayed
    $string = "{0}`n`n{1}`n{2}" -f $Error.Exception.Message,
                                   $Error.InvocationInfo.PositionMessage.Split('+')[0],
                                   $Error.CategoryInfo
    
    # Make sure the popup is on top of all other windows
    $top = New-Object System.Windows.Forms.Form -Property @{ TopMost = $true }

    # Display message box
    [System.Windows.Forms.MessageBox]::Show($top,$string,"Unexpected Error","Ok","Error") | Out-Null
}