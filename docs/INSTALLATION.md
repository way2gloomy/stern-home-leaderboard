# Installation Guide

## Prerequisites
- Docker and Docker Compose
- Stern Pinball account credentials

## Quick Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/way2gloomy/stern-home-leaderboard.git
   cd stern-home-leaderboard
   ```

2. **Configure non-secret environment variables**

   ```bash
   cp .env.example .env
   ```

   Edit `.env` and adjust `DEFAULT_COUNTRY`, `DEFAULT_STATE`, `DEFAULT_STATE_NAME`, `DEFAULT_CONTINENT`, `FRONTEND_PORT`, and any other optional settings as needed. Leave the `STERN_USERNAME`/`STERN_PASSWORD` lines alone — credentials are provided via the `secrets/` directory instead (see next step).

3. **Create the Stern credential secrets**
   ```bash
   mkdir -p secrets
   chmod 700 secrets
   printf 'your_stern_username\n' > secrets/stern_username
   printf 'your_stern_password\n' > secrets/stern_password
   chmod 600 secrets/stern_username secrets/stern_password
   ```

4. **Start the application**
   ```bash
   docker compose -f docker-compose.secrets.yml up -d
   ```

   This pulls the prebuilt multi-arch images from GHCR rather than building locally — no local build step needed, which matters on slower hardware like a Raspberry Pi. See the main [README](../README.md) for the local-build/dev workflow (`docker-compose.dev.yml`).

5. **Access the application**
   - Frontend: http://localhost:3000 (or your configured `FRONTEND_PORT`)
   - Fullscreen mode: http://localhost:3000?machine=MACHINE_ID&fullscreen=true (adjust port as needed)

   The backend API is not published to the host in this configuration — the frontend's nginx proxies `/api/*` to it internally. It's only reachable directly at `http://localhost:5100` when running `docker-compose.dev.yml`.

## Environment Variables

### Credentials
Stern credentials are read from the `secrets/` directory (`STERN_USERNAME_FILE`/`STERN_PASSWORD_FILE`, wired up automatically by `docker-compose.secrets.yml`), keeping them out of `.env` and out of `docker inspect`/process-environment output. See step 3 above.

If you don't need file-based secrets (e.g. a throwaway local test), `STERN_USERNAME`/`STERN_PASSWORD` can still be set directly as environment variables and used with plain `docker-compose.yml`, but this is not the recommended path for a real deployment.

### Optional
- `DEFAULT_COUNTRY`: Default country code (default: "US")
- `DEFAULT_STATE`: Default state code (default: "CO")
- `DEFAULT_STATE_NAME`: Default state name (default: "Colorado")
- `DEFAULT_CONTINENT`: Default continent code (default: "NA")
- `SESSION_SECRET`: A stronger session secret (a random one is generated per process start if unset)
- `CORS_ALLOWED_ORIGINS`: Comma-separated list of origins allowed to call the API (defaults to `localhost`/`127.0.0.1` on port 3000)

### Frontend Configuration
- `FRONTEND_PORT`: Port for the frontend web server (default: 3000)
  - Change this if port 3000 conflicts with other services
- `VITE_GRID_COLUMNS`: Number of columns for machine card layout (default: 1)
  - `1`: Single column layout (default)
  - `2`: Two columns side by side
  - `3`: Three columns side by side
  - `4+`: Four or more columns (automatically reduced on smaller screens)
- `VITE_DATA_REFRESH_INTERVAL_MINUTES`: How often to automatically refresh machine data in minutes (default: 60)

> **⚠️ Important**: Setting the refresh interval too low (less than 30 minutes) may result in account lockouts from Stern's API due to rate limiting. Use conservative refresh intervals to avoid service interruptions.

## Docker Deployment

```bash
# Start containers (pulls prebuilt GHCR images)
docker compose -f docker-compose.secrets.yml up -d

# View logs
docker compose -f docker-compose.secrets.yml logs -f

# Stop containers
docker compose -f docker-compose.secrets.yml down
```

For a Raspberry Pi deployment with an auto-starting systemd service and firewall rules, see the Pi-side hardening section of the main [README](../README.md).

## Local Development

For live reload with Docker, use `docker compose -f docker-compose.dev.yml up --build` (see the main [README](../README.md)).

To run outside Docker entirely:

### Frontend
```bash
cd frontend
npm install
npm run dev
```

### Backend
```bash
cd backend
npm install
npm run dev
```

This mode reads `STERN_USERNAME`/`STERN_PASSWORD` directly from your `.env` file rather than `secrets/`.
