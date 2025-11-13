# PSfunctions - typically PowerShell functions

## Get-InactiveTcpPort.ps1
A small inactive tcp port finder

## ConvertDistance.ps1 & ConvertDistance.Tests.ps1
Convert various units of distance to kilometers.

## Show-CertContents.ps1
A small certificate viewer</br>
Depends on openssl.exe, not included, and not referenced. **Suggestion:** Define an alias to your Openssl Path `New-Alias -Name openssl -Value $opensslPath`

## Send-AIChat.ps1
Sends a text prompt to the Google Gemini API for content generation.

This function acts as a wrapper for the Gemini API /generateContent endpoint.
It handles model selection either by common name (e.g., '2.5 Flash') or by raw model ID.
It defaults to the "2.5 Flash-Lite" Model, and it requires SecureString as input for Gemini ApiKey.
