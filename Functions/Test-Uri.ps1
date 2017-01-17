function Test-Uri {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Position = 0)]
        [string[]]$Uri,

        [Parameter()]
        [switch]$PrivateIpRange,

        [Parameter()]
        [switch]$PublicIpRance
    )

    BEGIN {
        $regexPattern = $global:UriRegexPattern
        $ipPattern = '^(?:\d{1,3}\.){3}\d{1,3}$'
    }

    PROCESS {
        foreach ($item in $Uri) {
            try {
                Write-Verbose "Testing '$($item)'"
                #[regex]::IsMatch($item,$regexPattern)
                $result = [regex]::Match($item,$regexPattern)
                #$result.Success

                if ($PrivateIpRange -or $PublicIpRance) {
                    $hostPart = $result.Groups | Where-Object {$_.Name -eq 'host'}
                    if ($hostPart) {
                        if ([regex]::IsMatch($hostPart.Value,$ipPattern)) {
                            $ipBytes = ([ipaddress]"$($hostPart.Value)").GetAddressBytes()
                            $privateAddress = $false
                            switch ($ipBytes) {
                                {$_[0] -eq 10} {$privateAddress = $true;break}
                                {$_[0] -eq 192 -and $_[1] -eq 168} {$privateAddress = $true;break}
                                {$_[0] -eq 172 -and $_[1] -ge 16 -and $_[1] -le 31 } {$privateAddress = $true;break}

                            }
                            $hostPart.Value
                            $privateAddress
                        }
                    }
                }



            }

            catch {
                Write-Warning $_.Exception.Message
            }
        }
    }
}