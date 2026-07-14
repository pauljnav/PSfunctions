function Enable-MicrophoneAccess {
    <#
    .SYNOPSIS
    Enables global microphone access.

    .DESCRIPTION
    Calls Set-MicrophoneAccess to enable global microphone access.

    .PARAMETER PassThru
    Returns the current microphone access state after the change.

    .PARAMETER Force
    Suppresses the default confirmation prompt unless Confirm is explicitly provided.

    .EXAMPLE
    Enable-MicrophoneAccess

    .EXAMPLE
    Enable-MicrophoneAccess -Force

    .EXAMPLE
    Enable-MicrophoneAccess -PassThru

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

    Set-MicrophoneAccess -Enable -PassThru:$PassThru -Force:$Force
}
