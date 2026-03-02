<#
.SYNOPSIS
Print your current public IPv4 address as a /32 CIDR value.

.AUTHOR
Shannon Eldridge-Kuehn c. 2026

.EXAMPLE
./Get-PublicIpCidr32.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

. "$PSScriptRoot/_Common.ps1"

Get-PublicIpv4Cidr32
