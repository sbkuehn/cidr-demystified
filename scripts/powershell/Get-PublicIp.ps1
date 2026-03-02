<#
.SYNOPSIS
Returns your current public IPv4 address.

.DESCRIPTION
Uses ipify (simple public IP service). Output is a single IPv4 string.

.EXAMPLE
./Get-PublicIp.ps1
#>

[CmdletBinding()]
param()

$resp = Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15
$resp.ip
