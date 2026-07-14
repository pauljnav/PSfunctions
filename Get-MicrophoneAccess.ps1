function Get-MicrophoneAccess {

<#
.SYNOPSIS
Gets the global microphone access status.

.DESCRIPTION
Retrieves the current Windows global microphone privacy setting.

This function reports whether global microphone access is enabled or
disabled. It does not modify the current microphone privacy setting.

.EXAMPLE
Get-MicrophoneAccess

Returns the current global microphone access status.

.EXAMPLE
Get-MicrophoneAccess | Format-List

Displays detailed microphone access information.

.OUTPUTS
System.Management.Automation.PSCustomObject

Returns an object describing the current microphone access state.

.LINK
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters

.COMPONENT
Windows Privacy Management

.ROLE
System Administration

.NOTES
Author: Paul Naughton
#>

    [CmdletBinding()]

    param()

    if ($env:OS -notmatch '^Windows') {
        throw "Get-MicrophoneAccess is supported only on Windows."
    }

    $Path = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone'

    if (-not (Test-Path $Path)) {
        throw "Registry path not found: $Path"
    }

    $Value = (Get-ItemProperty -Path $Path -Name Value).Value

    [PSCustomObject]@{
        Enabled       = ($Value -eq 'Allow')
        RegistryValue = $Value
        RegistryPath  = $Path
    }
}
