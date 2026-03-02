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
Restrict AKS API server access to your current public IPv4 address (/32).

.AUTHOR
Shannon Eldridge-Kuehn c. 2026

.DESCRIPTION
This sets the authorized IP ranges to only your current IP.
If you need multiple ranges, update this script to merge them.

.PARAMETER ResourceGroup
Resource group name.

.PARAMETER AksName
AKS cluster name.

.EXAMPLE
./Azure-Aks-AllowMyIp.ps1 -ResourceGroup myRg -AksName myAks
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$AksName
)

Assert-AzCliReady

$ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15).ip
$cidr = "$ip/32"

Write-Host "About to set AKS authorized IP ranges to: $cidr"
Write-Host "Cluster: $AksName (RG: $ResourceGroup)"
& az aks update -g $ResourceGroup -n $AksName --api-server-authorized-ip-ranges $cidr | Out-Host
Write-Host "Done."
