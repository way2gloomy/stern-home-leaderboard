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

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is not installed. Install Docker first." >&2
  exit 1
fi

APP_DIR="/opt/stern-home-leaderboard"
SERVICE_FILE="/etc/systemd/system/stern-home-leaderboard.service"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALL_USER="${SUDO_USER:-$(id -un)}"

mkdir -p "$APP_DIR"
cp "$REPO_ROOT/scripts/stern-home-leaderboard.service" "$SERVICE_FILE"
if [[ "$REPO_ROOT" != "$APP_DIR" ]]; then
  cp -a "$REPO_ROOT/." "$APP_DIR/"
fi
mkdir -p "$APP_DIR/secrets"
chmod 700 "$APP_DIR/secrets"
if [[ ! -f "$APP_DIR/.env" ]]; then
  cp "$APP_DIR/.env.example" "$APP_DIR/.env"
fi
if [[ ! -f "$APP_DIR/secrets/stern_username" ]]; then
  printf 'replace_with_stern_username\n' > "$APP_DIR/secrets/stern_username"
fi
if [[ ! -f "$APP_DIR/secrets/stern_password" ]]; then
  printf 'replace_with_stern_password\n' > "$APP_DIR/secrets/stern_password"
fi
chmod 600 "$APP_DIR/secrets/stern_username" "$APP_DIR/secrets/stern_password"
if [[ -d "$APP_DIR" ]]; then
  chown -R "$INSTALL_USER:$INSTALL_USER" "$APP_DIR"
fi

if grep -q 'replace_with_stern_' "$APP_DIR/secrets/stern_username" "$APP_DIR/secrets/stern_password"; then
  echo "Placeholder Stern credentials detected in $APP_DIR/secrets/. Update them before starting the stack." >&2
else
  systemctl daemon-reload
  systemctl enable stern-home-leaderboard.service
  systemctl restart stern-home-leaderboard.service
  systemctl status stern-home-leaderboard.service --no-pager || true
fi

ufw default deny incoming
ufw default allow outgoing
ufw allow from 192.168.10.0/24 to any port 3000 comment 'Allow dev subnet access'
ufw allow from 192.168.30.0/24 to any port 3000 comment 'Allow display subnet access'
ufw allow from 192.168.10.0/24 to any port 22 comment 'Allow SSH from dev subnet'
ufw --force enable
ufw status numbered
