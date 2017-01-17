$Global:UriRegexPattern = '(?:(?<scheme>\S+):)(?://)(?:(?<userinfo>(?:\S+)(?::\S*)?)@)?(?<host>[\u00A1-\uffff0-9a-z%][\u00A1-\uffff0-9a-z.%-]+(?<!\.))(?<path>/[\u00A1-\uffff0-9a-z_()/%]*)?(?<query>\?[\u00A1-\uffff0-9a-z=&%-]+)?(?<fragment>#[\u00A1-\uffff0-9a-z&=%-]+)?(?<port>:\d+)?(?:/)?'

Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Functions') | ForEach-Object {
    Get-ChildItem -Path $_.FullName | ForEach-Object {
        . $_.FullName
    }
}