#!/usr/bin/env bash
set -euo pipefail

# Returns your current public IPv4 address.
# Uses ipify (simple public IP service).
# Output: e.g. 203.0.113.7

curl -fsS https://api.ipify.org
echo
