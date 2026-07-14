function Set-MicrophoneAccess {

    <#
    .SYNOPSIS
    Enables or disables global microphone access.

    .DESCRIPTION
    Uses the Windows SystemSettingsAdminFlows executable to change the
    global microphone privacy setting.

    .PARAMETER Enable
    Enables global microphone access.

    .PARAMETER Disable
    Disables global microphone access.

    .EXAMPLE
    Set-MicrophoneAccess -Enable

    .EXAMPLE
    Set-MicrophoneAccess -Disable

    .EXAMPLE
    Set-MicrophoneAccess -Disable -WhatIf

    Shows the change that would be performed without modifying the current
    microphone privacy setting.

    .OUTPUTS
    System.Management.Automation.PSCustomObject

    Returns an object describing the requested microphone access change.

    .LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters

    .COMPONENT
    Windows Privacy Management

    .ROLE
    System Administration

    .NOTES
    Author: Paul Naughton
    #>

    [CmdletBinding(
        SupportsShouldProcess = $true,
        ConfirmImpact = 'High',
        DefaultParameterSetName = 'Enable'
    )]

    param(

        [Parameter(Mandatory, ParameterSetName = 'Enable')]
        [switch]$Enable,

        [Parameter(Mandatory, ParameterSetName = 'Disable')]
        [switch] $Disable
    )

    begin {

        $CommandInfo = Get-Command SystemSettingsAdminFlows.exe -ErrorAction SilentlyContinue

        if (-not $CommandInfo) {

            $CommandPath = Join-Path $env:windir 'System32\SystemSettingsAdminFlows.exe'

            if (Test-Path $CommandPath) {
                $CommandInfo = Get-Command $CommandPath
            }
        }

        if (-not $CommandInfo) {
            throw "SystemSettingsAdminFlows.exe was not found."
        }

        $Executable = $CommandInfo.Source

        $Value = if ($Enable) { 1 } else { 0 }
        $Action = if ($Enable) { 'Enable' } else { 'Disable' }
    }

    process {

        if ($PSCmdlet.ShouldProcess('Global Microphone Access', $Action)) {

            & $Executable SetCamSystemGlobal microphone $Value

            # check $? execution status of the last command
            if ($? -ne $true) {
                throw "SystemSettingsAdminFlows.exe failed with exit code $LASTEXITCODE."
            }

            Get-MicrophoneAccess
        }
    }
}
