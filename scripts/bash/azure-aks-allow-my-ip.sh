#!/usr/bin/env bash
set -euo pipefail

# Restrict AKS API server access to your current public IP (/32).
# Usage:
#   ./azure-aks-allow-my-ip.sh <resource-group> <aks-name>
#
# Note: This overwrites the full authorized IP ranges list to only include your current IP.
# If you have multiple allowed IPs, use the "append" script pattern instead.
#
# Author: Shannon B. Eldridge-Kuehn (2026)

RG="${1:-}"
AKS="${2:-}"

if [[ -z "$RG" || -z "$AKS" ]]; then
  echo "Usage: $0 <resource-group> <aks-name>"
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

echo "Setting AKS authorized IP ranges to: $MYIP"
echo "Cluster: $AKS (RG: $RG)"
az aks update -g "$RG" -n "$AKS" --api-server-authorized-ip-ranges "$MYIP"

echo "Done."
