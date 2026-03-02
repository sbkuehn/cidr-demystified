<#
.SYNOPSIS
Returns your current public IPv4 address as a /32 CIDR.

.EXAMPLE
./Get-PublicIpCidr32.ps1
#>

[CmdletBinding()]
param()

$ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15).ip
"{0}/32" -f $ip
