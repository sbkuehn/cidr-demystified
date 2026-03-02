#!/usr/bin/env bash
set -euo pipefail

# Author: Shannon Kuehn
# Purpose: Allowlist your current public IPv4 address (/32) on an Azure Key Vault firewall.
# Usage:
#   ./azure-keyvault-allow-my-ip.sh <resource-group> <keyvault-name>

RG="${1:-}"
KV="${2:-}"

if [[ -z "$RG" || -z "$KV" ]]; then
  echo "Usage: $0 <resource-group> <keyvault-name>"
  exit 2
fi

# Azure CLI checks
if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI (az) is required but was not found. Install it, then retry."
  exit 1
fi

if ! az account show >/dev/null 2>&1; then
  echo "You are not logged in to Azure CLI. Run: az login"
  exit 1
fi


MYIP="$(curl -fsS https://api.ipify.org)/32"

echo "About to allowlist $MYIP on Key Vault: $KV (RG: $RG)"
az keyvault network-rule add --resource-group "$RG" --name "$KV" --ip-address "$MYIP"

echo "Done."
