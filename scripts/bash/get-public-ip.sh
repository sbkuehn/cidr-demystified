#!/usr/bin/env bash
set -euo pipefail

# Author: Shannon Kuehn
# Purpose: Print your current public IPv4 address.
# Usage:
#   ./get-public-ip.sh

curl -fsS https://api.ipify.org
echo
