#!/usr/bin/env bash
set -euo pipefail

# Author: Shannon Eldridge-Kuehn c. 2026
# Purpose: Restrict AKS API server access to your current public IPv4 address (/32).
# Usage:
#   ./azure-aks-allow-my-ip.sh <resource-group> <aks-name>
#
# Note: This sets the authorized IP ranges to only your current IP.
# If you need multiple IP ranges, update this script to merge them.

RG="${1:-}"
AKS="${2:-}"

if [[ -z "$RG" || -z "$AKS" ]]; then
  echo "Usage: $0 <resource-group> <aks-name>"
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

echo "About to set AKS authorized IP ranges to: $MYIP"
echo "Cluster: $AKS (RG: $RG)"
az aks update -g "$RG" -n "$AKS" --api-server-authorized-ip-ranges "$MYIP"

echo "Done."
