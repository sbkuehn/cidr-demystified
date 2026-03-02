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

$resp = Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15
$resp.ip
