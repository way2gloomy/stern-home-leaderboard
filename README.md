<p align="center">
  <img src="frontend/public/pinball.svg" alt="Pinball Logo" width="80" height="80">
</p>

# Stern Home Leaderboard

A beautiful web application for displaying pinball machine high scores from your Stern Pinball home network. Connect to Stern's API to showcase machine data, high scores, and player avatars in a clean, modern interface.

<p align="center">
  <img src="screenshots/high-scores.png" alt="High Scores Display" width="800">
</p>

## ✨ Features

- **🏆 Real-time High Scores** - Live display of current high scores for all your registered machines
- **📱 Responsive Design** - Works beautifully on desktop, tablet, and mobile devices
- **🖥️ Fullscreen Mode** - Perfect for kiosks and dedicated displays next to your machines
- **🎨 Customizable** - Full CSS theming support with custom assets and fonts
- **⚡ Auto-refresh** - Configurable periodic refresh keeps scores current
- **🔧 Easy Setup** - Simple Docker deployment with minimal configuration

## 🚀 Quick Start (Docker Compose)

Pull and run the app using the prebuilt images:

```bash
# 1. Clone the repository
git clone https://github.com/way2gloomy/stern-home-leaderboard.git
cd stern-home-leaderboard

# 2. Create your environment file and edit non-secret settings as needed
cp .env.example .env
# Example: adjust DEFAULT_COUNTRY, DEFAULT_STATE, DEFAULT_STATE_NAME, DEFAULT_CONTINENT, FRONTEND_PORT, and any optional settings

# 3. Create the Stern credential secrets
mkdir -p secrets
chmod 700 secrets
printf 'your_stern_username\n' > secrets/stern_username
printf 'your_stern_password\n' > secrets/stern_password
chmod 600 secrets/stern_username secrets/stern_password

# 4. Start the application with the secrets-based compose file
docker compose -f docker-compose.secrets.yml up -d

# 5. Open in your browser
open http://localhost:3000
# (or your configured FRONTEND_PORT if changed)
```

`docker-compose.yml` and `docker-compose.secrets.yml` pull prebuilt multi-arch images from GHCR (`ghcr.io/way2gloomy/stern-home-leaderboard-{frontend,backend}:latest`), published by [`.github/workflows/publish-images.yml`](.github/workflows/publish-images.yml) on every push to `main`. This avoids building on-device, which matters on slower hardware like a Raspberry Pi 3. For local development with live reload from source, use `docker-compose.dev.yml` instead (see below).

## 🔐 Credentials and Security

The backend requires your Stern account credentials to authenticate with Stern's services.

### Configuration layout

- Use `.env` for non-secret runtime settings such as locale defaults (`DEFAULT_COUNTRY`, `DEFAULT_STATE`, `DEFAULT_STATE_NAME`, `DEFAULT_CONTINENT`), the frontend port, and optional security settings.
- Use the `secrets/` directory for Stern credentials. The backend reads these via `STERN_USERNAME_FILE` and `STERN_PASSWORD_FILE`, keeping the values out of the repository and out of `.env`.

Create the credential files with:

```bash
mkdir -p secrets
chmod 700 secrets
printf 'your_stern_username\n' > secrets/stern_username
printf 'your_stern_password\n' > secrets/stern_password
chmod 600 secrets/stern_username secrets/stern_password
```

The backend also supports these optional security settings:

- `SESSION_SECRET` for a stronger session secret
- `CORS_ALLOWED_ORIGINS` to restrict which hosts can call the API

### Pi-side hardening

For a Raspberry Pi deployment, the app now defaults to tighter local behavior:

- restricted CORS origin handling
- `httpOnly` and `sameSite` cookie settings for sessions
- input validation for machine and location identifiers

If you expose the app on your LAN, consider a host firewall such as `ufw` so only trusted subnets can reach it. For example, allow your dev subnet and your display/IOT subnet while blocking everything else.

On a Raspberry Pi, the helper script also installs a systemd service so the compose stack starts automatically after reboot. The service expects the repo to be installed at `/opt/stern-home-leaderboard`.

If you want a credential-free reinstall path, use the helper script at [scripts/pi-reinstall.sh](scripts/pi-reinstall.sh). It downloads the public repo archive directly from GitHub and re-runs the Pi setup without requiring Git credentials.

The Pi setup also creates a local `.env` file and a `secrets/` directory for the Stern credentials so the stack has a sane starting point after a fresh install.

## 🛠️ Quick Start for Development

Iterate locally with live reload using the dev compose file:

```bash
# 1. Clone the repository
git clone https://github.com/way2gloomy/stern-home-leaderboard.git
cd stern-home-leaderboard

# 2. Create your environment file and edit non-secret settings as needed
cp .env.example .env
# Example: adjust DEFAULT_COUNTRY, DEFAULT_STATE, DEFAULT_STATE_NAME, DEFAULT_CONTINENT, FRONTEND_PORT, and any optional settings

# 3. Create your Stern credential secrets
mkdir -p secrets
chmod 700 secrets
printf 'your_stern_username\n' > secrets/stern_username
printf 'your_stern_password\n' > secrets/stern_password
chmod 600 secrets/stern_username secrets/stern_password

# 4. Start dev containers (builds from local source)
docker compose -f docker-compose.dev.yml up --build

# Frontend dev server: http://localhost:3000
# Backend API:        http://localhost:5100
```

Hot reload is enabled via volume mounts; dependencies stay inside the container (`frontend_node_modules`, `backend_node_modules` named volumes).

## 📖 Documentation

| Guide                                             | Description                                         |
| ------------------------------------------------- | --------------------------------------------------- |
| **[📋 Installation](docs/INSTALLATION.md)**       | Complete setup guide with all configuration options |
| **[🎮 Features](docs/FEATURES.md)**               | Fullscreen mode, kiosk setup, and advanced features |
| **[🎨 Customization](docs/CUSTOMIZATION.md)**     | Themes, custom CSS, fonts, and visual modifications |
| **[🛠️ Development](docs/CONTRIBUTING.md)**        | Local development, architecture, and contributing   |
| **[🚨 Troubleshooting](docs/TROUBLESHOOTING.md)** | Common issues and solutions                         |

## 🙏 Attribution

This project is based on the work of the original author, [brombomb](https://github.com/brombomb). The current fork keeps that foundation while adding Raspberry Pi and local-home-network hardening work.

If you use or adapt this project, please keep that attribution in place.

## 📄 License

This project is for personal use with Stern Pinball machines. Please ensure compliance with [Stern's API terms of service](https://insider.sternpinball.com/).

---
