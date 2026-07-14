function Disable-MicrophoneAccess {
    <#
    .SYNOPSIS
    Disables global microphone access.

    .DESCRIPTION
    Calls Set-MicrophoneAccess to disable global microphone access.

    .PARAMETER PassThru
    Returns the current microphone access state after the change.

    .PARAMETER Force
    Suppresses the default confirmation prompt unless Confirm is explicitly provided.

    .EXAMPLE
    Disable-MicrophoneAccess

    .EXAMPLE
    Disable-MicrophoneAccess -Force

    .EXAMPLE
    Disable-MicrophoneAccess -PassThru

    .OUTPUTS
    None
        By default, this cmdlet returns no output.

    System.Management.Automation.PSCustomObject
        Returns the current microphone access state when you use the PassThru parameter.

    .NOTES
    Author: Paul Naughton
    #>

    [CmdletBinding()]
    param(
        [switch]$PassThru,
        [switch]$Force
    )

    Set-MicrophoneAccess -Disable -PassThru:$PassThru -Force:$Force
}