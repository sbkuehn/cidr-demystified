function Assert-AzCliReady {
    if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
        throw "Azure CLI (az) is required but was not found. Install it, then retry."
    }

    # Light login check
    $null = & az account show 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "You are not logged in to Azure CLI. Run: az login"
    }
}


<#
.SYNOPSIS
Create or update an NSG inbound rule to allow SSH (22) ONLY from your current public IP (/32).

.PARAMETER ResourceGroup
Resource group name.

.PARAMETER NsgName
Network Security Group name.

.PARAMETER RuleName
Rule name. Default: Allow-My-IP-SSH

.PARAMETER Priority
Rule priority. Default: 1000

.EXAMPLE
./Azure-Nsg-AllowMyIpSsh.ps1 -ResourceGroup myRg -NsgName myNsg
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$NsgName,

    [string]$RuleName = "Allow-My-IP-SSH",

    [int]$Priority = 1000
)

Assert-AzCliReady

$ip = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15).ip
$cidr = "$ip/32"

Write-Host "Creating/updating NSG rule: $RuleName"
Write-Host "NSG: $NsgName (RG: $ResourceGroup)"
Write-Host "Source: $cidr -> Destination port 22"

& az network nsg rule create `
  -g $ResourceGroup `
  --nsg-name $NsgName `
  -n $RuleName `
  --priority $Priority `
  --access Allow `
  --protocol Tcp `
  --direction Inbound `
  --source-address-prefixes $cidr `
  --source-port-ranges "*" `
  --destination-address-prefixes "*" `
  --destination-port-ranges 22 `
  --description "Allow SSH from my current public IP only" | Out-Host
