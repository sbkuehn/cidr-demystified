#!/usr/bin/env bash
set -euo pipefail

# Allow your current public IP (/32) to access an Azure Storage Account via firewall rules.
# Usage:
#   ./azure-storage-allow-my-ip.sh <resource-group> <storage-account-name>
#
# Author: Shannon B. Eldridge-Kuehn (2026)

RG="${1:-}"
SA="${2:-}"

if [[ -z "$RG" || -z "$SA" ]]; then
  echo "Usage: $0 <resource-group> <storage-account-name>"
  exit 2
fi

# Checks that Azure CLI is installed and user is logged in.
if ! command -v az >/dev/null 2>&1; then
  echo "Azure CLI (az) is required but was not found. Install it, then retry."
  exit 1
fi

# A light login check. If not logged in, this will fail quickly.
if ! az account show >/dev/null 2>&1; then
  echo "You are not logged in to Azure CLI. Run: az login"
  exit 1
fi


MYIP="$(curl -fsS https://api.ipify.org)/32"

echo "Allowlisting $MYIP on Storage Account: $SA (RG: $RG)"
az storage account network-rule add -g "$RG" --account-name "$SA" --ip-address "$MYIP"

echo "Done."
