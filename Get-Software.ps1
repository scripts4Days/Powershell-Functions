Function Get-Software
{
<#
.Synopsis
   Gets all software installed on a computer

.DESCRIPTION
   Looks through the registry to find all installed software. Can be run
   on a remote computer that has powershell remoting enabled. Returns the 
   following information DisplayName, Version, InstallDate, Publisher,
   EstimatedSize, UninstallString, Install Source 

.Parameter ComputerName
   The computer that you want to the script to run on.

.EXAMPLE
   Get-Software -ComputerName computer1

.INPUTS
   String

.OUTPUTS
   PsCustomObject
.NOTES
    Author: Matt Hussey
#>
    [CmdletBinding()]
    Param ( [String]$ComputerName = $env:COMPUTERNAME ) 

    If (!(Test-Connection -ComputerName $ComputerName -Count 1 -Quiet)) { throw "Unable to connect to $ComputerName" }
       
    Try
    { 
        $softwareArray = @()      
        ForEach ($Path in "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*","HKLM:SOFTWARE\Wow6432node\Microsoft\Windows\CurrentVersion\Uninstall\*") 
        {             
            If ($ComputerName -ne $env:COMPUTERNAME) 
            { 
                $regKeys = Invoke-Command -ComputerName $ComputerName -ArgumentList $Path -ErrorAction Stop -ScriptBlock `
                { 
                    Param ( [String]$path ) 
                    return $(Get-ItemProperty -Path $path) 
                } 
            }
            Else { $regKeys = Get-ItemProperty -Path $Path -ErrorAction Stop } 
               
            Foreach ($key in $regKeys)
            {                                
                If ($key.DisplayName -and $key.DisplayName -notmatch '^Update for|^Security Update|^Service Pack|^HotFix')
                {                       
                    $softwareArray += [pscustomobject]@{

                        DisplayName = $key.DisplayName
                
                        Version  = $key.DisplayVersion

                        InstallDate = $(Try { [datetime]::ParseExact($key.InstallDate, 'yyyyMMdd', $Null) } Catch { $null })

                        Publisher = $key.Publisher

                        EstimatedSizeMB = [decimal]([math]::Round(($key.EstimatedSize*1024)/1MB,2))

                        UninstallString = $key.UninstallString

                        InstallSource  = $key.InstallSource

                        ComputerName = $ComputerName
                    }
                }
            }       
        }
        Return $softwareArray
    }
    Catch { throw $Error[0] }
}