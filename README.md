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

## 🎯 Live Demo

**[👀 Try the Interactive Demo](https://brombomb.github.io/stern-home-leaderboard/)**

Experience the leaderboard features with sample data including:

- Game selection from Stern's catalog
- Dynamic themes and styling
- Toast notifications

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="screenshots/fullscreen.png" alt="Fullscreen Mode" width="400">
        <br>
        <strong>Fullscreen Kiosk Mode</strong>
        <br>
        <em>Perfect for displays next to your machines</em>
      </td>
      <td align="center">
        <img src="screenshots/tech-alerts.png" alt="Tech Alerts" width="400">
        <br>
        <strong>Machine Status Alerts</strong>
        <br>
        <em>Visual indicators for online/offline status</em>
      </td>
    </tr>
  </table>
</div>

## 🚀 Quick Start (Docker Compose)

Use the published images (no build required):

```bash
# 1. Clone the repository
git clone https://github.com/brombomb/stern-home-leaderboard.git
cd stern-home-leaderboard

# 2. Create your environment file
cp .env.example .env
# Edit .env with your Stern credentials if you want the simple local setup

# 3. Start the application
docker compose up -d

# 4. Open in your browser
open http://localhost:3000
# (or your configured FRONTEND_PORT if changed)
```

Images are published for `linux/amd64` and `linux/arm64` (Raspberry Pi friendly).

## 🔐 Credentials and Security

The backend requires your Stern account credentials to authenticate with Stern's services.

### Recommended for Raspberry Pi / Docker deployments

For Pi deployments, avoid storing credentials in a plain `.env` file whenever possible. The project now supports reading credentials from Docker secrets or host-mounted files:

```bash
mkdir -p secrets
chmod 700 secrets
printf 'your_stern_username\n' > secrets/stern_username
printf 'your_stern_password\n' > secrets/stern_password
chmod 600 secrets/stern_username secrets/stern_password
```

Then start the secrets-based compose file:

```bash
docker compose -f docker-compose.secrets.yml up -d --build
```

This uses the `STERN_USERNAME_FILE` and `STERN_PASSWORD_FILE` environment variables inside the backend container and keeps the values out of the project tree.

### Simpler local/dev option

If you are just testing locally, the original `.env` approach still works:

```bash
cp .env.example .env
# Edit .env with your Stern credentials
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

## 🛠️ Quick Start for Development

Iterate locally with live reload using the dev compose file:

```bash
# 1. Clone the repository
git clone https://github.com/brombomb/stern-home-leaderboard.git
cd stern-home-leaderboard

# 2. Create your environment file
cp .env.example .env
# Edit .env with your Stern credentials

# 3. Start dev containers (builds from local source)
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

This project is based on the work of the original author, [brombomb](https://github.com/brombomb). Their original implementation and project direction are the foundation for this fork and its Raspberry Pi / local-home-network hardening work.

If you use or adapt this project, please keep that attribution in place.

## 📄 License

This project is for personal use with Stern Pinball machines. Please ensure compliance with [Stern's API terms of service](https://insider.sternpinball.com/).

---
