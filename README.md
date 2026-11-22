# VyaparSetu AI

A B2B marketplace for Indian artisans, producers, and buyers. Producers publish products and quote buyer requests; buyers browse the catalog, post requirements, and confirm orders.

**Stack:** Flutter (Android + web) · Serverpod 4 (Dart backend) · PostgreSQL

## Live

| | |
| --- | --- |
| **Web app** | https://vyaparsetu.serverpod.space/ |
| **API** | https://vyaparsetu.api.serverpod.space/ |
| **Insights** | https://vyaparsetu.insights.serverpod.space/ |
| **Latest APK** | [vyaparsetu.apk](https://github.com/heytarshitgupta/VyaparSetu-TBT-/releases/latest/download/vyaparsetu.apk) |

The API, web build, and database run on **Serverpod Cloud** (project `vyaparsetu`, Europe). The APK is built by GitHub Actions on every push to `main` and uploaded to the `apk-latest` release, so the link above always serves the newest build.

## Install the Android app

1. Open [vyaparsetu.apk](https://github.com/heytarshitgupta/VyaparSetu-TBT-/releases/latest/download/vyaparsetu.apk) on the phone.
2. Allow installs from the browser when Android asks.
3. Sign in with an email address; the 6-digit OTP arrives in that inbox.

## Run locally

Requirements: Flutter 3.50.1, Dart 3.14, Serverpod CLI 4.1.2, Docker Desktop.

```powershell
git clone https://github.com/heytarshitgupta/VyaparSetu-TBT-.git
cd VyaparSetu-TBT-\vyaparsetu_ai

# Local secrets (first run only). Replace the placeholders in the file.
Copy-Item vyaparsetu_ai_server\config\passwords.yaml.example vyaparsetu_ai_server\config\passwords.yaml

# Start PostgreSQL
cd vyaparsetu_ai_server
docker compose up -d postgres
cd ..

# Start the backend and the Flutter app
flutter pub get
serverpod start --no-docker
```

Create a `.env` next to `docker-compose.yaml` with `VYAPARSETU_DEV_DB_PASSWORD=<same database password>` so the container and the server agree.

The runner prints the Flutter preview URL (usually `http://localhost:8095`); the API listens on `http://localhost:8080`. If SMTP is not configured, OTP codes are printed in the server console.

## Deploy

Backend and database are hosted on Serverpod Cloud. Ship a new backend version with:

```powershell
cd vyaparsetu_ai\vyaparsetu_ai_server
serverpod cloud deploy
```

Cloud secrets are managed per project:

```powershell
serverpod cloud password set smtpUser you@example.com
serverpod cloud password set smtpPass "your-gmail-app-password"
serverpod cloud password set serverSideSessionKeyHashPepper <random-value>
```

To refresh the hosted web app, rebuild it into the server's `web/app` folder and redeploy:

```powershell
cd vyaparsetu_ai
serverpod run flutter_build
cd vyaparsetu_ai_server
serverpod cloud deploy
```

The APK needs no manual step: push to `main` and `.github/workflows/android-apk.yml` builds it with `SERVER_URL=https://vyaparsetu.api.serverpod.space/` and replaces the release asset. Set the repository variable `SERVER_URL` to override the API URL.

## Project layout

```
vyaparsetu_ai/
├── vyaparsetu_ai_flutter/   Flutter app (buyer + producer, Android + web)
├── vyaparsetu_ai_server/    Serverpod backend, migrations, hosted web build
└── vyaparsetu_ai_client/    Generated Dart client (do not edit)
```

## Tests

```powershell
cd vyaparsetu_ai
dart analyze
cd vyaparsetu_ai_flutter; flutter test
cd ..\vyaparsetu_ai_server; dart test
```
