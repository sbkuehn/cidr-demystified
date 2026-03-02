function Assert-AzCliReady {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        throw "Azure CLI (az) is required but was not found. Install it, then retry."
    }

    $null = & az account show 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "You are not logged in to Azure CLI. Run: az login"
    }
}


<#
.SYNOPSIS
Allowlist your current public IPv4 address (/32) on an Azure Key Vault firewall.

.AUTHOR
Shannon Kuehn

.PARAMETER ResourceGroup
Resource group name.

.PARAMETER KeyVaultName
Key Vault name.

.EXAMPLE
./Azure-KeyVault-AllowMyIp.ps1 -ResourceGroup myRg -KeyVaultName myVault
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$KeyVaultName
)

Assert-AzCliReady

$ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15).ip
$cidr = "$ip/32"

Write-Host "About to allowlist $cidr on Key Vault: $KeyVaultName (RG: $ResourceGroup)"
& az keyvault network-rule add --resource-group $ResourceGroup --name $KeyVaultName --ip-address $cidr | Out-Host
Write-Host "Done."
