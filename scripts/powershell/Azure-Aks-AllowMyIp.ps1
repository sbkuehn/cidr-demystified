<#
.SYNOPSIS
Restrict AKS API server access to your current public IPv4 address (/32).

.AUTHOR
Shannon Kuehn

.PARAMETER ResourceGroup
Resource group name.

.PARAMETER AksName
AKS cluster name.

.PARAMETER MergeExisting
If set, merges your current IP into the existing Authorized IP ranges rather than overwriting.

.PARAMETER WhatIf
Shows what would happen if the command runs. No changes are made.

.EXAMPLE
./Azure-Aks-AllowMyIp.ps1 -ResourceGroup myRg -AksName myAks

.EXAMPLE
./Azure-Aks-AllowMyIp.ps1 -ResourceGroup myRg -AksName myAks -MergeExisting

.NOTES
Uses Az.Aks cmdlets (no Azure CLI).
This changes the AKS control plane allowlist. Be careful not to lock yourself out.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$AksName,

    [switch]$MergeExisting,

    [switch]$WhatIf
)

. "$PSScriptRoot/_Common.ps1"
Assert-AzPowerShellReady

$cidr = Get-PublicIpv4Cidr32
$ranges = @($cidr)

if ($MergeExisting) {
    $cluster = Get-AzAksCluster -ResourceGroupName $ResourceGroup -Name $AksName
    $existing = @()

    if ($cluster.ApiServerAccessProfile -and $cluster.ApiServerAccessProfile.AuthorizedIPRanges) {
        $existing = @($cluster.ApiServerAccessProfile.AuthorizedIPRanges)
    }

    $ranges = @($existing + $cidr | Sort-Object -Unique)
}

Write-Host "About to set AKS authorized IP ranges to:"
$ranges | ForEach-Object { Write-Host "  - $_" }

if ($WhatIf) {
    Write-Host "WhatIf: Set-AzAksCluster -ResourceGroupName $ResourceGroup -Name $AksName -ApiServerAccessAuthorizedIpRange <ranges>"
    return
}

$null = Set-AzAksCluster -ResourceGroupName $ResourceGroup -Name $AksName -ApiServerAccessAuthorizedIpRange $ranges

Write-Host "Done."
