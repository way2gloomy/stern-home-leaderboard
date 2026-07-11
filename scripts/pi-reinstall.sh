#!/usr/bin/env bash
set -euo pipefail

if [[ $(id -u) -ne 0 ]]; then
  echo "Please run this script as root or with sudo." >&2
  exit 1
fi

REPO_URL="${REPO_URL:-https://github.com/way2gloomy/stern-home-leaderboard}"
BRANCH="${BRANCH:-main}"
INSTALL_DIR="/opt/stern-home-leaderboard"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

ARCHIVE="$TMP_DIR/repo.tar.gz"

if command -v curl >/dev/null 2>&1; then
  curl -fsSL "${REPO_URL}/archive/refs/heads/${BRANCH}.tar.gz" -o "$ARCHIVE"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "$ARCHIVE" "${REPO_URL}/archive/refs/heads/${BRANCH}.tar.gz"
else
  echo "Neither curl nor wget is available. Install one of them first." >&2
  exit 1
fi

tar -xzf "$ARCHIVE" -C "$TMP_DIR"
EXTRACTED_DIR="$(find "$TMP_DIR" -maxdepth 1 -mindepth 1 -type d | head -n 1)"
if [[ -z "$EXTRACTED_DIR" ]]; then
  echo "Failed to locate the extracted repository directory." >&2
  exit 1
fi

if [[ -d "$INSTALL_DIR/secrets" ]]; then
  cp -a "$INSTALL_DIR/secrets" "$TMP_DIR/secrets-backup"
fi

rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
cp -a "$EXTRACTED_DIR/." "$INSTALL_DIR/"

if [[ -d "$TMP_DIR/secrets-backup" ]]; then
  mkdir -p "$INSTALL_DIR/secrets"
  cp -a "$TMP_DIR/secrets-backup/." "$INSTALL_DIR/secrets/"
fi

chmod +x "$INSTALL_DIR/scripts/pi-setup.sh"
"$INSTALL_DIR/scripts/pi-setup.sh"
