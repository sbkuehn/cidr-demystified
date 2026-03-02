# CIDR Demystified: Helper Scripts (Bash + PowerShell)

This repo contains small, practical scripts used in the accompanying blog entry on CIDR notation (IPv4 and IPv6) and "allow my current IP" workflows.

The goal is simple:
- Find your current public IPv4 address
- Produce a /32 CIDR value for allowlists
- Optionally apply that allowlist to common Azure resources (Key Vault, Storage, AKS API server, NSG rule)

## Prereqs

### Bash scripts
- macOS or Linux
- `curl`
- Optional: Azure CLI (`az`) if you use the Azure scripts

### PowerShell scripts
- PowerShell 7+ recommended (`pwsh`) on Windows, macOS, or Linux
- Optional: Azure CLI (`az`) if you use the Azure scripts

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

These scripts are intentionally minimal and interactive-friendly. They:
1) detect your public IP
2) convert it to `/32`
3) run the relevant `az` command

You must be logged in to Azure CLI first:
```bash
az login
```

## Scripts

### Bash
- `get-public-ip.sh`
- `get-public-ip-cidr32.sh`
- `azure-keyvault-allow-my-ip.sh`
- `azure-storage-allow-my-ip.sh`
- `azure-aks-allow-my-ip.sh`
- `azure-nsg-allow-my-ip-ssh.sh`

### PowerShell
- `Get-PublicIp.ps1`
- `Get-PublicIpCidr32.ps1`
- `Azure-KeyVault-AllowMyIp.ps1`
- `Azure-Storage-AllowMyIp.ps1`
- `Azure-Aks-AllowMyIp.ps1`
- `Azure-Nsg-AllowMyIpSsh.ps1`

## Notes

- These examples use IPv4 because most allowlist entry points still accept IPv4 reliably. Many services also accept IPv6, but behavior differs across products and org policies.
- Your public IP can change, especially on consumer ISPs and while traveling. Re-run the scripts when needed.
- For longer-term patterns, consider Private Endpoints, VPN, Azure Bastion, or a fixed egress NAT.

## License
MIT. See [LICENSE](LICENSE).
