function Set-MicrophoneAccess {

    <#
    .SYNOPSIS
    Enables or disables global microphone access.

    .DESCRIPTION
    Uses the Windows SystemSettingsAdminFlows executable to change the global microphone privacy setting.

    .PARAMETER Enable
    Enables global microphone access.

    .PARAMETER Disable
    Disables global microphone access.

    .PARAMETER PassThru
    By default, this cmdlet doesn't output anything. With PassThru, the cmdlet returns
    an object describing the requested microphone access change.

    .PARAMETER Force
    Suppresses default confirmation prompts for this cmdlet. If Confirm is explicitly provided,
    the explicit Confirm setting is honored.

    .EXAMPLE
    Set-MicrophoneAccess -Enable

    .EXAMPLE
    Set-MicrophoneAccess -Disable

    .EXAMPLE
    Set-MicrophoneAccess -Disable -WhatIf

    Shows the change that would be performed without modifying the current
    microphone privacy setting.

    .EXAMPLE
    Set-MicrophoneAccess -Disable -Force

    Disables global microphone access without the default confirmation prompt.

    .OUTPUTS
    None
        By default, this cmdlet returns no output.

    System.Management.Automation.PSCustomObject
        The cmdlet returns an object describing the requested microphone access change when you use the PassThru parameter.

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
        [switch]$Disable,

        [switch]$PassThru,

        [switch]$Force
    )

    begin {

        if ($env:OS -notmatch '^Windows') {
            throw "Set-MicrophoneAccess is supported only on Windows."
        }

        $CommandInfo = Get-Command SystemSettingsAdminFlows.exe -ErrorAction SilentlyContinue

        if (-not $CommandInfo) {
            throw "SystemSettingsAdminFlows.exe was not found."
        }

        $Value = if ($Enable) { 1 } else { 0 }
        $Action = if ($Enable) { 'Enable' } else { 'Disable' }

        # If Confirm is explicitly provided, honor it; otherwise Force suppresses the
        # default ShouldProcess confirmation in function scope.
        if ($Force.IsPresent -and -not $PSBoundParameters.ContainsKey('Confirm')) {
            $ConfirmPreference = 'None'
        }
    }

    process {

        if ($PSCmdlet.ShouldProcess('Global Microphone Access', $Action)) {

            SystemSettingsAdminFlows.exe SetCamSystemGlobal microphone $Value

            # check $? execution status of the last command
            if ($? -ne $true) {
                throw "SystemSettingsAdminFlows.exe failed with exit code $LASTEXITCODE."
            }

            if ($PassThru.IsPresent) {
                Start-Sleep -Milliseconds 400
                Get-MicrophoneAccess
            }
        }
    }
}
