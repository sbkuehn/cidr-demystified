<#
.SYNOPSIS
Allowlist your current public IPv4 address (/32) on an Azure Storage Account firewall.

.AUTHOR
Shannon Kuehn

.PARAMETER ResourceGroup
Resource group name.

.PARAMETER StorageAccountName
Storage account name.

.PARAMETER WhatIf
Shows what would happen if the command runs. No changes are made.

.EXAMPLE
./Azure-Storage-AllowMyIp.ps1 -ResourceGroup myRg -StorageAccountName mystorageacct

.NOTES
Uses Az.Storage cmdlets (no Azure CLI).
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$StorageAccountName,

    [switch]$WhatIf
)

. "$PSScriptRoot/_Common.ps1"
Assert-AzPowerShellReady

$cidr = Get-PublicIpv4Cidr32

Write-Host "About to allowlist $cidr on Storage Account: $StorageAccountName (RG: $ResourceGroup)"

if ($WhatIf) {
    Write-Host "WhatIf: Add-AzStorageAccountNetworkRule -ResourceGroupName $ResourceGroup -Name $StorageAccountName -IPAddressOrRange $cidr"
    return
}

$null = Add-AzStorageAccountNetworkRule -ResourceGroupName $ResourceGroup -Name $StorageAccountName -IPAddressOrRange $cidr

Write-Host "Done."
