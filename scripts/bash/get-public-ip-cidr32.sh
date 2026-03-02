#!/usr/bin/env bash
set -euo pipefail

# Author: Shannon Eldridge-Kuehn c. 2026
# Purpose: Print your current public IPv4 address as a /32 CIDR value.
# Usage:
#   ./get-public-ip-cidr32.sh

IP="$(curl -fsS https://api.ipify.org)"
echo "${IP}/32"
