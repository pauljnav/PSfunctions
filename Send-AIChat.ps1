function Send-AIChat
{
<#
.SYNOPSIS
    Sends a text prompt to the Google Gemini API for content generation.

.DESCRIPTION
    This function acts as a wrapper for the Gemini API /generateContent endpoint.
    It handles model selection either by common name (e.g., '2.5 Flash') or by raw model ID.
    It defaults to the "2.5 Flash-Lite" Model, and it requires SecureString as input for Gemini ApiKey.

.PARAMETER ModelName
    The friendly name of the Gemini model to use.
    Example: '2.5 Flash', '2.5 Pro'.

.PARAMETER ModelID
    The raw API model ID can be specified as the Gemini model to use.
    Example: 'gemini-2.5-flash'.

.PARAMETER AIPrompt
    The text prompt you want to send to the AI model.

.PARAMETER GeminiApiKey
    Your Google Gemini API key (SecureString) required for authentication.

.PARAMETER PlainResponse
    Function returns a plain text response, not as an api response object.

.EXAMPLE
    # 1. Basic usage using the friendly ModelName
    $GEMINI_API_KEY = [SecureString]"YOUR_API_KEY_HERE"
    $prompt = 'Write a short poem about coding.'
    Send-AIChat -ModelName '2.5 Flash' -AIPrompt $prompt -GeminiApiKey $GEMINI_API_KEY

.EXAMPLE
    # 2. Using ModelID with -PlainResponse
    $GEMINI_API_KEY = [SecureString]"YOUR_API_KEY_HERE"
    $prompt = 'Suggest 2 project ideas.'
    Send-AIChat -ModelID 'gemini-2.5-flash-lite' -AIPrompt $prompt -GeminiApiKey $GEMINI_API_KEY -PlainResponse

.EXAMPLE
    # 3. Write a haiku, output as Plain Response
    $prompt = "haiku"
    Send-AIChat -ModelName '2.5 Flash-Lite' -AIPrompt $prompt -GeminiApiKey $GEMINI_API_KEY -PlainResponse

.NOTES
    - Author: Paul Naughton
    - Date: Nov 2025
#>
    [CmdletBinding(DefaultParameterSetName = 'ModelName',
                   HelpUri = 'https://ai.google.dev/gemini-api/docs/')]
    [Alias("ChatGemini")]

    param(
        [Parameter(ParameterSetName = 'ModelName')]
        [ValidateSet("2.5 Pro", "2.5 Flash", "2.5 Flash-Lite", "Veo 3.1", "Gemini 2.5 Flash Image", "Gemini Embeddings")]
        [string]$ModelName="2.5 Flash-Lite",

        [Parameter(ParameterSetName = 'ModelID')]
        [ValidateSet("gemini-2.5-pro", "gemini-2.5-flash", "gemini-2.5-flash-lite", "veo-3.1", "gemini-2.5-flash-image", "gemini-embeddings")]
        [string]$ModelID="gemini-2.5-flash-lite",

        [Parameter(Mandatory)]
        [string]$AIPrompt,

        [Parameter(Mandatory)]
        [SecureString]$GeminiApiKey,

        [Parameter()]
        [switch]$PlainResponse
    )

    begin {
        # 1. Define base API URL
        $baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models'

        # 2. Define the static model map for ModelName lookup
        $modelMap = ConvertFrom-Json -InputObject @' 
{
  "2.5 Pro": {
    "id": "gemini-2.5-pro"
  },
  "2.5 Flash": {
    "id": "gemini-2.5-flash"
  },
  "2.5 Flash-Lite": {
    "id": "gemini-2.5-flash-lite"
  },
  "Veo 3.1": {
    "id": "veo-3.1"
  },
  "Gemini 2.5 Flash Image": {
    "id": "gemini-2.5-flash-image"
  },
  "Gemini Embeddings": {
    "id": "gemini-embeddings"
  }
}
'@

        # 3. Determine the final Model ID
        if ($PSCmdlet.ParameterSetName -eq 'ModelName') {
            $finalModelID = $modelMap."$ModelName".id
        } else {
            $finalModelID = $ModelID
        }

        # 4. Construct the full API URI
        $apiUri = "$baseUrl/${finalModelID}:generateContent"

        # 5. Define the JSON body using a here-string for direct JSON text.
        $bodyJson = @"
{
    "contents": [
      {
        "parts": [
          {
            "text": "$AIPrompt"
          }
        ]
      }
    ]
}
"@

        # 6. Load the assembly required for memory manipulation
        if (-not ([System.Reflection.Assembly]::LoadWithPartialName("System.Runtime.InteropServices") )) {
            Add-Type -AssemblyName System.Runtime.InteropServices
        }

        # 7. Convert SecureString to a BSTR pointer (unmanaged memory)
        # Note: SecureStringToBSTR allocates unmanaged memory.
        $bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($GeminiApiKey)

        # 8. Convert BSTR pointer to a managed, plain string
        try {
            # Use PtrToStringAuto on Windows, but PtrToStringBSTR is often safer/more cross-platform.
            # Since you are likely on Windows, Auto usually works.
            $plainApiKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($bstr)
        }
        finally {
            # 9. Always zero out and free the unmanaged memory pointer immediately
            [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)
        }

        # 10. Use $plainApiKey in your headers:
        $headers = @{
            'x-goog-api-key' = $plainApiKey 
            'Content-Type'   = 'application/json'
        }

        # 11. Define parameters for Invoke-RestMethod (using splatting)
        $iwrParams = @{
            Uri       = $apiUri
            Method    = 'Post'
            Headers   = $headers
            Body      = $bodyJson
            UserAgent = "Send-AIChat/PowerShell"
        }
    }

    process {
        Write-Verbose "Calling API: $apiUri with Model ID: $finalModelID"

        try {
            # Invoke the REST method as WebRequest (for better data).
            $response = (Invoke-WebRequest @iwrParams)
            
            # PlainResponse or Response object
            if ( $PSBoundParameters.ContainsKey('PlainResponse') ){
                Write-Output $response.Content | ConvertFrom-Json |
                    ForEach-Object candidates | ForEach-Object content |
                    ForEach-Object parts | ForEach-Object text
            } else {
                # Output the response object to the pipeline
                Write-Output $response.Content
            }
        }
        catch {
            Write-Error "API Request Failed: $($_.Exception.Message)"
            Write-Verbose "API Response Headers: $($_.Exception.Response.Headers)"
        }
    }
}
