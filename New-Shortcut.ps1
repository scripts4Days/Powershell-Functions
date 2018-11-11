Function New-Shortcut
{
    <#
.Synopsis
   Creates a shortcut

.Description
   Author: Matt Hussey

.PARAMETER ExecutablePath
   Path to the program you want the shortcut to launch

.PARAMETER ShortcutName
   Name of the shortcut

.PARAMETER Destination
   Location that you want shortcut placed at

.PARAMETER Arguments
   Add any arguments to the shortcut

.PARAMETER ComputerName
   Name of computer you want to add shortcut to. Default is local computer

.Example
   New-Shortcut -ExecutablePath "C:\Windows\system32\notepad.exe" -ShortcutName "Notepad" -Destination "C:\Users\User1\Desktop" -ComputerName computer1
   Creates a shortcut on computer1 to launch notepad. Shortcut name will be Notepad and be located on user1's dekstop.  
#>
    [CmdletBinding()]
    Param
    (
        # Path to program you want shortcut to launch
        [Parameter(Mandatory = $true,
            Position = 0)]
        [String]$ExecutablePath,

        # Name of the shortcut
        [Parameter(Mandatory = $true,
            Position = 1)]
        [String]$ShortcutName,

        # Location you want the shortcut placed at
        [Parameter(Position = 2)]
        [String]$Destination = "C:\Users\Public\Desktop",
        
        # Add any arguments to the shortcut
        [String]$Arguments = $null,

        # Computer you want the shortcut on
        [String]$ComputerName = $env:COMPUTERNAME
    )

    if ($ComputerName -ne $env:COMPUTERNAME) 
    { 
        if (Test-Path -Path $Destination)
        {
            if ($Destination -notlike "\\$Computername\c$\*")
            {
                if ($Destination -like "C:*") { $Destination = $Destination.Replace("C:", "\\$ComputerName\c$") }
                else { throw "Invalid path $_" }
            }
        }
        else { throw "Unable to locate destiantion path $_" }
    }
    
    try
    {
        $comObj = New-Object -ComObject WScript.Shell
        $shortcut = $comObj.CreateShortcut(("{0}\{1}.lnk" -f $Destination, $ShortcutName))
        $shortcut.TargetPath = $ExecutablePath
        if ($Arguments) { $shortcut.Arguments = $Arguments }
        $shortcut.Save() 
    }
    catch { throw $_ }
}