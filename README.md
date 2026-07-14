# PSfunctions - typically PowerShell functions

## Get-InactiveTcpPort.ps1
[Get-InactiveTcpPort.ps1](/Get-InactiveTcpPort.ps1)
A small inactive tcp port finder

## ConvertDistance.ps1 & ConvertDistance.Tests.ps1
[ConvertDistance.ps1](/ConvertDistance.ps1)

Convert various units of distance to kilometers.

## Show-CertContents.ps1
[Show-CertContents.ps1](/Show-CertContents.ps1)
A small certificate viewer</br>
Depends on openssl.exe, not included, and not referenced. **Suggestion:** Define an alias to your Openssl Path `New-Alias -Name openssl -Value $opensslPath`

## Send-AIChat.ps1
[Send-AIChat.ps1](/Send-AIChat.ps1)
Sends a text prompt to the Google Gemini API for content generation.

This function acts as a wrapper for the Gemini API /generateContent endpoint.
It handles model selection either by common name (e.g., '2.5 Flash') or by raw model ID.
It defaults to the "2.5 Flash-Lite" Model, and it requires SecureString as input for Gemini ApiKey.

## Test-EmailAddress.ps1
[Test-EmailAddress.ps1](/Test-EmailAddress.ps1)
Validates an email address using the .NET MailAddress parser.  
If successful, it returns the decorated object. If parsing fails, it returns $false.
Consider additional validation as the .NET MailAddress parser used is not perfect for validating all email addresses.

## Get-MyBlog.ps1
[Get-MyBlog.ps1](/Get-MyBlog.ps1)
Get-MyBlog opens my blog https://pauljnav.github.io in the default browser when no blog -Name parameter is provided. When -Name is specified, the function resolves the url slug to the full URL from the blog feed via ArgumentCompleter() method.

## MicrophoneAccess

[Get-MicrophoneAccess.ps1](/Get-MicrophoneAccess.ps1)
Gets the current Windows global microphone privacy setting, and teturns the current microphone access state,

[Set-MicrophoneAccess.ps1](/Set-MicrophoneAccess.ps1)
Enables or disables global microphone access using the Windows SystemSettingsAdminFlows executable. Supports ShouldProcess for -WhatIf and -Confirm.

[Enable-MicrophoneAccess.ps1](/Enable-MicrophoneAccess.ps1)
Calls Set-MicrophoneAccess to enable global microphone access.

[Disable-MicrophoneAccess.ps1](/Disable-MicrophoneAccess.ps1)
Calls Set-MicrophoneAccess to disable global microphone access.
