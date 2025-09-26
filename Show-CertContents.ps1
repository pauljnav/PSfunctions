

function Show-CertContents() {
    param(
        # specify cert display options
        [Parameter(Mandatory)][string[]] $certificate,
        [Parameter()][Switch] $no_issuer,
        [Parameter()][Switch] $no_subject,
        [Parameter()][Switch] $no_header,
        [Parameter()][Switch] $no_version,
        [Parameter()][Switch] $no_serial,
        [Parameter()][Switch] $no_signame,
        [Parameter()][Switch] $no_validity,
        [Parameter()][Switch] $no_pubkey,
        [Parameter()][Switch] $no_sigdump,
        [Parameter()][Switch] $no_aux,
        [Parameter()][Switch] $no_extensions
    )
    
    
    # basiccertoptions is the default option collection
    [string]$certoptions = 'no_header,no_version,no_serial,no_signame,no_validity,no_pubkey,no_sigdump,no_aux,no_extensions'
    
    # all switcho options start with 'no_', is user selects from any switch parameter,
    # the function begins adding options to a blank certoptions string.
    if ($PSBoundParameters.Keys -match 'no_') {
        $certoptions = ''
    }

    # Given certoptions contains empty string, first join will place ',' at the start
    # TrimStart() after the switch block adjusts for that.
    switch ($PSBoundParameters.Keys) {
        'no_issuer' { $certoptions = $certoptions, 'no_issuer' -join ',' }
        'no_subject' { $certoptions = $certoptions, 'no_subject' -join ',' }
        'no_header' { $certoptions = $certoptions, 'no_header' -join ',' }
        'no_version' { $certoptions = $certoptions, 'no_version' -join ',' }
        'no_signame' { $certoptions = $certoptions, 'no_signame' -join ',' }
        'no_validity' { $certoptions = $certoptions, 'no_validity' -join ',' }
        'no_pubkey' { $certoptions = $certoptions, 'no_pubkey' -join ',' }
        'no_sigdump' { $certoptions = $certoptions, 'no_sigdump' -join ',' }
        'no_aux' { $certoptions = $certoptions, 'no_aux' -join ',' }
        'no_extensions' { $certoptions = $certoptions, 'no_extensions' -join ',' }
    }
    # TrimStart() after the switch block adjusts the string.
    $certoptions = $certoptions.TrimStart(',')
        
    #$certoptions = "no_issuer,no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_pubkey,no_sigdump,no_aux,no_extensions"
    #$certoptions = "no_header,no_version,no_serial,no_signame,no_validity,no_pubkey,no_sigdump,no_aux,no_extensions"

    $opensslCmd = "openssl x509 -text -in `"$certificate`" -certopt $certoptions"
    Write-Host $certoptions
    Write-Host $opensslCmd

    & $opensslCmd
    # Invoke-Expression $opensslCmd - deprecate the use of Invoke-Expression
}