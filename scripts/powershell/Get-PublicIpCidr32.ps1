<#
.SYNOPSIS
Print your current public IPv4 address as a /32 CIDR value.

.AUTHOR
Shannon Kuehn

.EXAMPLE
./Get-PublicIpCidr32.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15).ip
"$ip/32"
