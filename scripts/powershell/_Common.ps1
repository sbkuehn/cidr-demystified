<#
Common helpers for this repo.

Shannon Eldridge-Kuehn c. 2026
#>

function Assert-AzPowerShellReady {
    $needed = @(
        "Az.Accounts",
        "Az.KeyVault",
        "Az.Storage",
        "Az.Network",
        "Az.Aks"
    )

    foreach ($m in $needed) {
        if (-not (Get-Module -ListAvailable -Name $m)) {
            throw "Missing module: $m. Install with: Install-Module Az -Scope CurrentUser"
        }
    }

    if (-not (Get-AzContext -ErrorAction SilentlyContinue)) {
        throw "No Azure context found. Run: Connect-AzAccount"
    }
}

function Get-PublicIpv4 {
    $resp = Invoke-RestMethod -Uri "https://api.ipify.org?format=json" -Method Get -TimeoutSec 15
    return $resp.ip
}

function Get-PublicIpv4Cidr32 {
    $ip = Get-PublicIpv4
    return "$ip/32"
}
