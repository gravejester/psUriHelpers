function Select-Uri {
    <#
            .SYNOPSIS
            Finds URIs in strings and files.
            .DESCRIPTION
            The Select-Uri function searches for URIs in a string or in a file.
            .EXAMPLE
            $string | Select-Uri
            Will find URIs in $string and output as text.
            .EXAMPLE
            $string | Select-Uri -AsObject
            Will find URIs in $string and output as System.URI types.
            .EXAMPLE
            Select-Uri -Path '.\file.txt'
            Will find URIs in .\file.txt and output as text.
            .NOTES
            Author: Øyvind Kallstad
            Version: 1.0
            Date:  11.01.2017
            .LINK
            https://communary.net/
    #>
    [CmdletBinding(DefaultParameterSetName = 'String')]
    param (
        # Get URIs from string.
        [Parameter(ValueFromPipeline = $true, Position = 0, ParameterSetName = 'String')]
        [string]$String,

        # Get URIs from file.
        [Parameter(ValueFromPipeline = $true, Position = 0, ParameterSetName = 'Path')]
        [string]$Path,

        # Output found URIs as URI objects.
        [Parameter()]
        [switch]$AsObject
    )

    $regexPattern = '(?:(?<scheme>\S+):)(?://)(?:(?<userinfo>(?:\S+)(?::\S*)?)@)?(?<host>[\u00A1-\uffff0-9a-z%][\u00A1-\uffff0-9a-z.%-]+(?<!\.))(?<path>/[\u00A1-\uffff0-9a-z_()/%]*)?(?<query>\?[\u00A1-\uffff0-9a-z=&%-]+)?(?<fragment>#[\u00A1-\uffff0-9a-z&=%-]+)?(?<port>:\d+)?(?:/)?'

    try {

        if ($PSCmdlet.ParameterSetName -eq 'Path') {
            $String = Get-Content -Path $Path -Raw
        }

        $matches = Select-String -InputObject $String -Pattern $regexPattern -AllMatches
        Write-Verbose "Found $($matches.Matches.Count) URIs"

        if ($AsObject) {
            foreach ($match in $matches.Matches) {
                Write-Output ([uri]::new($match.Value))
            }
        }
        else {
            Write-Output ($matches.Matches | Select-Object -ExpandProperty Value)
        }

    }

    catch {
        Write-Warning $_.Exception.Message
    }

}