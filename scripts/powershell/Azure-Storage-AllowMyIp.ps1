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
Allowlist your current public IPv4 address (/32) on an Azure Storage Account firewall.

.AUTHOR
Shannon Kuehn

.PARAMETER ResourceGroup
Resource group name.

.PARAMETER StorageAccountName
Storage account name.

.EXAMPLE
./Azure-Storage-AllowMyIp.ps1 -ResourceGroup myRg -StorageAccountName mystorageacct
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$StorageAccountName
)

Assert-AzCliReady

$ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15).ip
$cidr = "$ip/32"

Write-Host "About to allowlist $cidr on Storage Account: $StorageAccountName (RG: $ResourceGroup)"
& az storage account network-rule add -g $ResourceGroup --account-name $StorageAccountName --ip-address $cidr | Out-Host
Write-Host "Done."
