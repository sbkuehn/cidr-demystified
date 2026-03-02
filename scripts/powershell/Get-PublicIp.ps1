<#
.SYNOPSIS
Print your current public IPv4 address.

.AUTHOR
Shannon Kuehn

.EXAMPLE
./Get-PublicIp.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot/_Common.ps1"

Get-PublicIpv4
