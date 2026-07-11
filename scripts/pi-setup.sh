#!/usr/bin/env bash
set -euo pipefail

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run this script as root or with sudo." >&2
  exit 1
fi

if ! command -v ufw >/dev/null 2>&1; then
  echo "ufw is not installed. Install it with: apt install ufw" >&2
  exit 1
fi

ufw default deny incoming
ufw default allow outgoing
ufw allow from 192.168.10.0/24 to any port 3000 comment 'Allow dev subnet access'
ufw allow from 192.168.30.0/24 to any port 3000 comment 'Allow display subnet access'
ufw allow from 192.168.10.0/24 to any port 22 comment 'Allow SSH from dev subnet'
ufw --force enable
ufw status numbered
