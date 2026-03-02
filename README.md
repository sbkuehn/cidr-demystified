# CIDR Demystified (Scripts + Notes)

Practical helper scripts to go with a conversational CIDR explainer (IPv4 and IPv6) and the very real cloud task we all do: allowlisting your current source IP.

Author: Shannon Eldridge-Kuehn c. 2026

## What’s in here

- `scripts/bash/` for macOS and Linux
- `scripts/powershell/` for PowerShell (pwsh recommended)
- `docs/` for blog copy, diagrams, and reference links
- `.github/workflows/` for basic CI smoke tests

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

## Azure scripts

These scripts assume you have Azure CLI installed and you are logged in:

```bash
az login
az account show
```

Examples:

```bash
scripts/bash/azure-keyvault-allow-my-ip.sh myRg myVault
scripts/bash/azure-storage-allow-my-ip.sh myRg mystorageacct
scripts/bash/azure-aks-allow-my-ip.sh myRg myAks
scripts/bash/azure-nsg-allow-my-ip-ssh.sh myRg myNsg
```

PowerShell equivalents:

```powershell
./scripts/powershell/Azure-KeyVault-AllowMyIp.ps1 -ResourceGroup myRg -KeyVaultName myVault
./scripts/powershell/Azure-Storage-AllowMyIp.ps1 -ResourceGroup myRg -StorageAccountName mystorageacct
./scripts/powershell/Azure-Aks-AllowMyIp.ps1 -ResourceGroup myRg -AksName myAks
./scripts/powershell/Azure-Nsg-AllowMyIpSsh.ps1 -ResourceGroup myRg -NsgName myNsg
```

## Safety notes

- These scripts help you allowlist a single IPv4 address as `/32`. Your public IP can change, especially on consumer ISPs and while traveling.
- Some scripts overwrite settings (not merge). Read the header comments before running.
- For long lived patterns, consider Private Endpoints, VPN, Bastion, or fixed egress NAT.

## License

MIT. See [LICENSE](LICENSE).
