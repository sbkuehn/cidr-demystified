#!/usr/bin/env bash
set -euo pipefail

# Create or update an NSG inbound rule to allow SSH (22) ONLY from your current public IP (/32).
# Usage:
#   ./azure-nsg-allow-my-ip-ssh.sh <resource-group> <nsg-name> [rule-name] [priority]
#
# Defaults:
#   rule-name: Allow-My-IP-SSH
#   priority: 1000

RG="${1:-}"
NSG="${2:-}"
RULE="${3:-Allow-My-IP-SSH}"
PRIORITY="${4:-1000}"

if [[ -z "$RG" || -z "$NSG" ]]; then
  echo "Usage: $0 <resource-group> <nsg-name> [rule-name] [priority]"
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

echo "Creating/updating NSG rule: $RULE"
echo "NSG: $NSG (RG: $RG)"
echo "Source: $MYIP -> Destination port 22"
az network nsg rule create   -g "$RG"   --nsg-name "$NSG"   -n "$RULE"   --priority "$PRIORITY"   --access Allow   --protocol Tcp   --direction Inbound   --source-address-prefixes "$MYIP"   --source-port-ranges "*"   --destination-address-prefixes "*"   --destination-port-ranges 22   --description "Allow SSH from my current public IP only"

echo "Done."
