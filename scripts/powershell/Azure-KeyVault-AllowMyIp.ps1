<#
.SYNOPSIS
Allowlist your current public IPv4 address (/32) on an Azure Key Vault firewall.

.AUTHOR
Shannon Kuehn

.PARAMETER ResourceGroup
Resource group name.

.PARAMETER KeyVaultName
Key Vault name.

.PARAMETER WhatIf
Shows what would happen if the command runs. No changes are made.

.EXAMPLE
./Azure-KeyVault-AllowMyIp.ps1 -ResourceGroup myRg -KeyVaultName myVault

.NOTES
Uses Az.KeyVault cmdlets (no Azure CLI).
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$KeyVaultName,

    [switch]$WhatIf
)

. "$PSScriptRoot/_Common.ps1"
Assert-AzPowerShellReady

$cidr = Get-PublicIpv4Cidr32

Write-Host "About to allowlist $cidr on Key Vault: $KeyVaultName (RG: $ResourceGroup)"

if ($WhatIf) {
    Write-Host "WhatIf: Add-AzKeyVaultNetworkRule -VaultName $KeyVaultName -ResourceGroupName $ResourceGroup -IpAddressRange $cidr"
    return
}

$kv = Get-AzKeyVault -VaultName $KeyVaultName -ResourceGroupName $ResourceGroup
$null = Add-AzKeyVaultNetworkRule -InputObject $kv -IpAddressRange $cidr

Write-Host "Done."
