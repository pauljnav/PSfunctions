function Get-MyBlog {
    <#
    .SYNOPSIS
    Opens my blog homepage or a specific blog post.

    .DESCRIPTION
    Get-MyBlog opens https://pauljnav.github.io in the default browser when no name is provided.
    When -Name is specified, the function resolves the slug to the full URL from the blog feed.

    .PARAMETER Name
    The blog post slug to open.

    .EXAMPLE
    Get-MyBlog
    Opens the blog homepage.

    .EXAMPLE
    Get-MyBlog -Name Contributing-to-PSAISuite-a-practical-guide
    Opens the specified blog post.

    .NOTES
    Alias: blog, myblog
    #>
    [CmdletBinding()]
    [Alias('blog', 'myblog')]
    param(
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete)

                $baseUrl = 'https://pauljnav.github.io'
                $feedUrl = "$baseUrl/feed.xml"
                $UA = "Get-MyBlog/1.0 (+https://github.com/pauljnav; @pauljnav)"

                # Static cache avoids repeated HTTP calls during tab completion
                if (-not $MyBlogFeed) {
                    try {
                        $MyBlogFeed = Invoke-RestMethod -Uri $feedUrl -UserAgent $UA
                    }
                    catch {
                        return
                    }
                }

                $posts = $MyBlogFeed |
                Select-Object @{N = 'Date' ; E = { (Get-Date $_.published -Format 'yyyy-MM-dd') } },
                @{N = 'Title'  ; E = { $_.title.'#text' } },
                @{N = 'Slug'   ; E = { ([uri]$_.id).Segments[-1].Trim('/') } },
                @{N = 'Url'    ; E = { $_.id } },
                @{N = 'Summary'; E = { $_.summary } }

                foreach ($post in $posts) {
                    if ($post.Slug -like "*$wordToComplete*") {
                        [System.Management.Automation.CompletionResult]::new(
                            $post.Slug,
                            $post.Slug,
                            'ParameterValue',
                            "$($post.Date)  $($post.Summary.InnerText)"
                        )
                    }
                }
            })]
        [string]$Name,
        [Switch]$List
    )

    # Define vars for function execution
    # items in completer runspace are not exposed to the function
    $baseUrl = 'https://pauljnav.github.io'
    $feedUrl = "$baseUrl/feed.xml"
    $UA = "Get-MyBlog/1.0 (+https://github.com/pauljnav; @pauljnav)"

    # Without name, open homepage
    if (-not $Name) {
        Start-Process $baseUrl
        return
    }

    # Fetch feed for function execution
    # items in completer runspace are not exposed to the function
    try {
        $items = Invoke-RestMethod -Uri $feedUrl -UserAgent $UA
    }
    catch {
        Write-Warning "Unable to retrieve blog feed."
        return
    }

    if ($List) {
        $items |
        Select-Object @{N = 'Date'; E = { Get-Date $_.published -Format 'yyyy-MM-dd' } },
        @{N = 'Slug'; E = { ([uri]$_.id).Segments[-1].Trim('/') } },
        @{N = 'Title'; E = { $_.title.'#text' } }
        return
    }

    # Resolve slug to URL
    $post = $items | Where-Object {
        ([uri]$_.id).Segments[-1].Trim('/') -eq $Name
    }

    if ($post.id) {
        Start-Process $post.id
    }
    else {
        Write-Warning "Blog post '$Name' not found in feed."
    }
}
