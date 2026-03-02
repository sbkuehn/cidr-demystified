#!/usr/bin/env bash
set -euo pipefail

# Returns your current public IPv4 address as a /32 CIDR.
# Output: e.g. 203.0.113.7/32

IP="$(curl -fsS https://api.ipify.org)"
echo "${IP}/32"
