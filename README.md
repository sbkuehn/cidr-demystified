# CIDR Demystified (Scripts + Notes)

Practical helper scripts to go with a conversational CIDR explainer (IPv4 and IPv6) and the very real cloud task we all do: allowlisting your current source IP.

Author: Shannon Kuehn

## What’s in here

- `scripts/bash/` for macOS and Linux
- `scripts/powershell/` for **native Azure PowerShell (Az modules)**
- `docs/` for blog copy, diagrams, and reference links
- `.github/workflows/` for basic CI smoke tests

## Prereqs

### Bash scripts
- macOS or Linux
- `curl`
- Optional: Azure CLI (`az`) if you use the Azure bash scripts

### PowerShell scripts (native Az PowerShell)
- PowerShell 7+ recommended (`pwsh`) on Windows, macOS, or Linux
- Az PowerShell modules:
  - Az.Accounts
  - Az.KeyVault
  - Az.Storage
  - Az.Network
  - Az.Aks

Install (one time) from an elevated PowerShell prompt:

```powershell
Install-Module Az -Scope CurrentUser
```

Sign in:

```powershell
Connect-AzAccount
```

## Quick start

### Bash

```bash
chmod +x scripts/bash/*.sh

scripts/bash/get-public-ip.sh
scripts/bash/get-public-ip-cidr32.sh
```

### PowerShell

```powershell
./scripts/powershell/Get-PublicIp.ps1
./scripts/powershell/Get-PublicIpCidr32.ps1
```

## Azure examples

### Bash (Azure CLI)

```bash
az login
az account show

scripts/bash/azure-keyvault-allow-my-ip.sh myRg myVault
scripts/bash/azure-storage-allow-my-ip.sh myRg mystorageacct
scripts/bash/azure-aks-allow-my-ip.sh myRg myAks
scripts/bash/azure-nsg-allow-my-ip-ssh.sh myRg myNsg
```

### PowerShell (Az modules)

```powershell
Connect-AzAccount

./scripts/powershell/Azure-KeyVault-AllowMyIp.ps1 -ResourceGroup myRg -KeyVaultName myVault
./scripts/powershell/Azure-Storage-AllowMyIp.ps1 -ResourceGroup myRg -StorageAccountName mystorageacct
./scripts/powershell/Azure-Aks-AllowMyIp.ps1 -ResourceGroup myRg -AksName myAks
./scripts/powershell/Azure-Nsg-AllowMyIpSsh.ps1 -ResourceGroup myRg -NsgName myNsg
```

## Safety notes

- These scripts allowlist a single IPv4 address as `/32`. Your public IP can change, especially on consumer ISPs and while traveling.
- Read the header comments before running. Some scripts can overwrite settings, while others can merge.
- For long lived patterns, consider Private Endpoints, VPN, Bastion, or fixed egress NAT.

## License

MIT. See [LICENSE](LICENSE).
