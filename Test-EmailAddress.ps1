function Test-EmailAddress {
    <#
    .SYNOPSIS
        Validates an email address using the .NET MailAddress parser.
    .DESCRIPTION
        Attempts to parse a string into a [System.Net.Mail.MailAddress] object.
        If successful, it returns the decorated object. If parsing fails, it returns $false.
    .PARAMETER Email
        The email address string to validate. Supports pipeline input.
    .PARAMETER Simple
        If specified, the function returns a simple Boolean (True/False) regardless of success.
    .EXAMPLE
        Test-EmailAddress "paul@example.com"
        Returns a MailAddress object with an added .IsValid property.
    .EXAMPLE
        Test-EmailAddress "paul@example.com" -Simple
        Returns $true for valid address.
    .EXAMPLE
        "invalid..email@" | Test-EmailAddress
        Returns $false for non-valid address.
    .NOTES
        Consider additional validation as the .NET MailAddress parser used is not perfect for validating all email addresses.
        As an example, it will accept invalid addresses like user@domain..tld (double .)
        The RFC allow for addresses that are technically valid but not commonly used.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [string]$Email,

        [Switch]$Simple
    )

    process {
        try {
            # Attempt to create the native MailAddress object
            $addr = [System.Net.Mail.MailAddress]::new($Email)

            # If -Simple is used, just return true now
            if ($Simple.IsPresent) { return $true }

            # Otherwise, decorate the object with IsValid
            $addr | Add-Member -NotePropertyName IsValid -NotePropertyValue $true -Force

            return $addr
        }
        catch {
            # failure - return $false regardless of switches
            return $false
        }
    }
}
