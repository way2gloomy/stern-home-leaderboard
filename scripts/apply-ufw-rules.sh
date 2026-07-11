#!/usr/bin/env bash
set -euo pipefail

if ! command -v ufw >/dev/null 2>&1; then
  echo "ufw is not installed on this system." >&2
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo." >&2
  exit 1
fi

ufw default deny incoming
ufw default allow outgoing

# Allow the app from your dev subnet and the future IoT/display subnet
ufw allow from 192.168.10.0/24 to any port 3000 comment 'Allow app from dev subnet'
ufw allow from 192.168.30.0/24 to any port 3000 comment 'Allow app from IoT/display subnet'

# Optional: allow SSH from your dev subnet only
ufw allow from 192.168.10.0/24 to any port 22 comment 'Allow SSH from dev subnet'

ufw --force enable
ufw status numbered
