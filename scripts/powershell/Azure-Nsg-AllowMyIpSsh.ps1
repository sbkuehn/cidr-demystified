<#
.SYNOPSIS
Create or update an NSG rule to allow SSH (22) only from your current public IPv4 address (/32).

.AUTHOR
Shannon Kuehn

.PARAMETER ResourceGroup
Resource group name.

.PARAMETER NsgName
Network Security Group name.

.PARAMETER RuleName
Rule name. Default: Allow-My-IP-SSH

.PARAMETER Priority
Priority. Default: 1000

.PARAMETER WhatIf
Shows what would happen if the command runs. No changes are made.

.EXAMPLE
./Azure-Nsg-AllowMyIpSsh.ps1 -ResourceGroup myRg -NsgName myNsg

.NOTES
Uses Az.Network cmdlets (no Azure CLI).
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$NsgName,

    [string]$RuleName = "Allow-My-IP-SSH",

    [int]$Priority = 1000,

    [switch]$WhatIf
)

. "$PSScriptRoot/_Common.ps1"
Assert-AzPowerShellReady

$cidr = Get-PublicIpv4Cidr32

Write-Host "About to create or update NSG rule: $RuleName"
Write-Host "NSG: $NsgName (RG: $ResourceGroup)"
Write-Host "Source: $cidr -> Destination port 22"

if ($WhatIf) {
    Write-Host "WhatIf: update NSG rule config then Set-AzNetworkSecurityGroup"
    return
}

$nsg = Get-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroup -Name $NsgName
$existingRule = $nsg.SecurityRules | Where-Object { $_.Name -eq $RuleName }

if ($null -ne $existingRule) {
    $nsg = Set-AzNetworkSecurityRuleConfig `
        -NetworkSecurityGroup $nsg `
        -Name $RuleName `
        -Description "Allow SSH from my current public IP only" `
        -Access Allow `
        -Protocol Tcp `
        -Direction Inbound `
        -Priority $Priority `
        -SourceAddressPrefix $cidr `
        -SourcePortRange "*" `
        -DestinationAddressPrefix "*" `
        -DestinationPortRange 22
} else {
    $nsg = Add-AzNetworkSecurityRuleConfig `
        -NetworkSecurityGroup $nsg `
        -Name $RuleName `
        -Description "Allow SSH from my current public IP only" `
        -Access Allow `
        -Protocol Tcp `
        -Direction Inbound `
        -Priority $Priority `
        -SourceAddressPrefix $cidr `
        -SourcePortRange "*" `
        -DestinationAddressPrefix "*" `
        -DestinationPortRange 22
}

$null = Set-AzNetworkSecurityGroup -NetworkSecurityGroup $nsg

Write-Host "Done."
