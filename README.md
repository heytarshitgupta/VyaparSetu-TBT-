# VyaparSetu AI

A two-sided B2B marketplace for Indian artisans, producers, and bulk buyers. Producers publish products and send quotes; buyers browse the catalog, post requirements, and confirm orders.

**Stack:** Flutter (Android + web) · Serverpod 4 (Dart backend) · PostgreSQL

---

## Live deployment

| Service | URL |
| --- | --- |
| **Web app** | https://vyaparsetu.serverpod.space/ |
| **API** | https://vyaparsetu.api.serverpod.space/ |
| **Insights** | https://vyaparsetu.insights.serverpod.space/ |
| **Latest APK** | https://github.com/heytarshitgupta/VyaparSetu-TBT-/releases/latest/download/vyaparsetu.apk |

Everything runs on **Serverpod Cloud** (project `vyaparsetu`, region Europe, Starter plan). The managed PostgreSQL database lives inside the same project, so there is no separate database host to configure. The web frontend is served by the Serverpod web server from `vyaparsetu_ai_server/web/app`. The APK is built by GitHub Actions and attached to the `apk-latest` GitHub Release, which keeps the download link above permanent.

---

## What the app does

**Producers** complete a business profile, add products (photo + description, optional AI-generated catalog text), publish or hide listings, browse buyer requirements, quote a total in rupees, and see confirmed orders.

**Buyers** browse and search published products, add items to a wishlist, post requirements, request a quote, receive notifications, and accept a quote to confirm an order.

Sign-in is passwordless: the user enters an email address, receives a 6-digit OTP by Gmail SMTP, and verifies it. In local development the OTP is printed to the server console when SMTP is not configured.

---

## How it is put together

```
┌──────────────────────────────┐
│ Flutter app                  │
│  • Android APK               │
│  • Web build (web/app)       │
└──────────────┬───────────────┘
               │ Serverpod RPC over HTTPS
┌──────────────▼───────────────┐
│ Serverpod backend            │
│  • endpoints (Dart)          │
│  • email OTP auth            │
│  • web server (FlutterRoute) │
│  • migrations + seed data    │
└──────────────┬───────────────┘
               │
┌──────────────▼───────────────┐
│ PostgreSQL (managed)         │
└──────────────────────────────┘
```

- `vyaparsetu_ai_client/` is generated from the server's `.spy.yaml` models and endpoint signatures. Never edit it by hand.
- The server serves `web/app` at `/` when that directory exists (`FlutterRoute` in `lib/server.dart`). If it is missing, a "Flutter web app not built" page is shown.
- Product photos are stored through Serverpod cloud storage (`ServerpodCloudProvider`, with `DatabaseCloudStorage` as fallback).
- Optional AI catalog generation uses `GEMINI_API_KEY` (or `LLM_API_KEY`); without a key a deterministic artisan template is used.
- Demo catalog seeding runs only when `runMode == 'development'`, so production starts empty.

---

## Install the Android app

1. Open https://github.com/heytarshitgupta/VyaparSetu-TBT-/releases/latest/download/vyaparsetu.apk on the phone.
2. Allow installs from the browser when Android asks (Settings → Apps → Special access → Install unknown apps).
3. Sign in with an email address; the OTP arrives in that inbox.

Every push to `main` produces a new APK with an incremented build number, so installing a newer download upgrades the existing app.

---

## Run locally

### Prerequisites

- Flutter **3.50.1** (Dart 3.14)
- Serverpod CLI **4.1.2** (`dart pub global activate serverpod_cli 4.1.2`)
- Docker Desktop (for the local PostgreSQL container)

### 1. Clone and install dependencies

```powershell
git clone https://github.com/heytarshitgupta/VyaparSetu-TBT-.git
cd VyaparSetu-TBT-\vyaparsetu_ai
flutter pub get
```

### 2. Create local secrets (first run only)

Run this from `vyaparsetu_ai_server/`. It fills every `replace-with-*` placeholder with a random value and writes the matching database passwords to `.env`, which `docker compose` reads.

```powershell
cd vyaparsetu_ai_server

$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$values = @{}
$template = Get-Content -Raw config\passwords.yaml.example
foreach ($placeholder in [regex]::Matches($template, 'replace-with-[a-z-]+').Value) {
  $bytes = New-Object byte[] 32
  $rng.GetBytes($bytes)
  $values[$placeholder] = -join ($bytes | ForEach-Object { $_.ToString('x2') })
  $template = $template.Replace($placeholder, $values[$placeholder])
}
$rng.Dispose()
Set-Content config\passwords.yaml $template -Encoding ASCII

@(
  "VYAPARSETU_DEV_DB_PASSWORD=$($values['replace-with-development-db-password'])"
  "VYAPARSETU_DEV_REDIS_PASSWORD=$($values['replace-with-development-redis-password'])"
  "VYAPARSETU_TEST_DB_PASSWORD=$($values['replace-with-test-db-password'])"
  "VYAPARSETU_TEST_REDIS_PASSWORD=$($values['replace-with-test-redis-password'])"
) | Set-Content .env -Encoding ASCII
```

To send real OTP emails locally, edit `config/passwords.yaml` and set `smtpUser` / `smtpPass` (a Gmail app password). Without them the code is logged instead.

### 3. Start PostgreSQL

```powershell
# still inside vyaparsetu_ai_server
docker compose up -d postgres
```

The container listens on `127.0.0.1:8090`, matching `config/development.yaml`.

### 4. Start the backend and the Flutter app

```powershell
# from vyaparsetu_ai_server
serverpod start --no-docker
```

The runner applies pending migrations, starts the API on `http://localhost:8080`, the web server on `8082`, and launches the Flutter app (configured under `serverpod: flutter_apps:` in `vyaparsetu_ai_server/pubspec.yaml`). The Flutter preview URL is printed in the terminal, usually `http://localhost:8095`.

`--no-docker` tells Serverpod not to start its own database container because Docker Compose already provides PostgreSQL.

### 5. Stop everything

```powershell
docker compose stop postgres
```

---

## Common tasks

| Task | Command (from the shown directory) |
| --- | --- |
| Resolve dependencies | `vyaparsetu_ai/` → `flutter pub get` |
| Regenerate client + server code | `vyaparsetu_ai_server/` → `serverpod generate` (the runner does this automatically while running) |
| Create a migration after model changes | `vyaparsetu_ai_server/` → `serverpod create-migration` |
| Apply migrations manually | `vyaparsetu_ai_server/` → `dart run bin/main.dart --apply-migrations` |
| Repair migration drift | `vyaparsetu_ai_server/` → `serverpod create-repair-migration` |
| Rebuild the hosted web app | `vyaparsetu_ai/` → `serverpod run flutter_build` |
| Build an APK manually | `vyaparsetu_ai_flutter/` → `flutter build apk --release --dart-define=SERVER_URL=https://vyaparsetu.api.serverpod.space/` |
| Analyze Dart code | `vyaparsetu_ai/` → `dart analyze` |
| Format Dart code | `vyaparsetu_ai/` → `dart format .` |
| Run backend tests | `vyaparsetu_ai_server/` → `dart test` |
| Run Flutter tests | `vyaparsetu_ai_flutter/` → `flutter test` |

The server tests use Serverpod's embedded PostgreSQL (`config/test.yaml`), so no Docker container is needed.

---

## Configuration reference

| File / variable | Purpose |
| --- | --- |
| `vyaparsetu_ai_server/config/development.yaml` | Local ports and database (`localhost:8090`). |
| `vyaparsetu_ai_server/config/production.yaml` | Placeholder only; Serverpod Cloud injects the real host, ports, and domains at deploy time. |
| `vyaparsetu_ai_server/config/passwords.yaml` | Local secrets. Gitignored — never commit it. |
| `vyaparsetu_ai_server/.env` | `docker compose` passwords (`VYAPARSETU_DEV_DB_PASSWORD`, etc.). Gitignored. |
| `SMTP_USER` / `SMTP_PASS` | Environment overrides for the Gmail sender. |
| `GEMINI_API_KEY` / `LLM_API_KEY` | Optional key for AI catalog generation. |
| `SERVER_URL` | Flutter `--dart-define` that points the app at an API host. |
| `vyaparsetu_ai_server/scloud.yaml` | Serverpod Cloud project link (`projectId: vyaparsetu`). Safe to commit. |

### API endpoints

| Endpoint | Methods |
| --- | --- |
| `profile` | `getMine`, `completeOnboarding`, `verifyProducerPan`, `requireMarketplaceProfile` |
| `product` | `createDraft`, `updateDraft`, `publish`, `hide`, `deleteDraft`, `listMyDrafts`, `listMyProducts`, `catalog`, `getPhoto` |
| `trade` | `requestQuote`, `quote`, `accept`, `listMine` |
| `marketplace_extra` | `wishlist`, `toggleWishlist`, `listRequirements`, `createRequirement`, `respondRequirement`, `notifications`, `markNotificationRead`, `sellerStats` |
| `utility` | `suggestedPrice`, `calculatePrice`, `generateCatalogDescription`, `improvePhoto` |

Serverpod exposes each method as `POST https://<api-host>/<endpoint>/<method>` with JSON arguments. All calls use the authenticated session.

---

## Deploy the backend

The project is already linked to Serverpod Cloud. To ship backend changes:

```powershell
cd vyaparsetu_ai\vyaparsetu_ai_server
serverpod cloud deploy
```

`deploy` uploads the server package, builds it in the cloud, applies pending migrations, and rolls out API + web + Insights together.

### Cloud secrets

Secrets are stored per project, never in the repository:

```powershell
serverpod cloud password set smtpUser you@example.com
serverpod cloud password set smtpPass "your-gmail-app-password"
serverpod cloud password set serverSideSessionKeyHashPepper <random-hex-value>
```

Serverpod Cloud manages `database`, `serviceSecret`, `emailSecretHashPepper`, JWT keys, and the Cloud email key automatically. Re-deploy after changing a secret.

### Refresh the hosted web app

```powershell
cd vyaparsetu_ai
serverpod run flutter_build          # builds Flutter web into vyaparsetu_ai_server/web/app
cd vyaparsetu_ai_server
serverpod cloud deploy               # uploads and serves it at https://vyaparsetu.serverpod.space/
```

`web/app` is gitignored, but `vyaparsetu_ai_server/.scloudignore` explicitly re-includes it so the deploy uploads the build.

### Useful cloud commands

```powershell
serverpod cloud status live              # podlets, health, assigned URLs
serverpod cloud log --limit 50           # runtime logs
serverpod cloud password list            # managed and custom secrets
serverpod cloud project show             # plan, region, trial, database size
```

### Self-hosting alternative

`vyaparsetu_ai_server/Dockerfile` is a working multi-stage build (`dart build cli` + Alpine runtime, `role=monolith`). It can be deployed to any container host (Railway, Render, Fly.io, Cloud Run) with a PostgreSQL instance and the same secrets as environment variables.

---

## APK releases

`.github/workflows/android-apk.yml` runs on every push to `main` and on manual dispatch:

1. Installs Java 17, Flutter 3.50.1, and resolves the workspace.
2. Builds `flutter build apk --release --build-number=<run number> --dart-define=SERVER_URL=<api url>`.
3. Uploads `vyaparsetu.apk` to the `apk-latest` GitHub Release with `--clobber`, and marks it the latest release.

The stable link is:

```
https://github.com/heytarshitgupta/VyaparSetu-TBT-/releases/latest/download/vyaparsetu.apk
```

To point a build at a different API, set the repository variable `SERVER_URL` (Settings → Secrets and variables → Actions → Variables). The workflow falls back to `https://vyaparsetu.api.serverpod.space/`.

Release APKs are signed with the debug key outside Serverpod Cloud builds. That is fine for direct distribution but not for Play Store publishing; configure a real keystore in `android/app/build.gradle.kts` for that.

---

## Project layout

```
VyaparSetu-TBT-/
├── .github/workflows/android-apk.yml   APK build + latest release
├── README.md
└── vyaparsetu_ai/                      Dart workspace root
    ├── pubspec.yaml                    Workspace definition
    ├── vyaparsetu_ai_flutter/          Flutter app
    │   ├── lib/buyer_section/          Buyer screens
    │   ├── lib/producer_section/       Producer screens
    │   ├── lib/features/               Auth, marketplace, shared flows
    │   └── lib/client.dart             SERVER_URL resolution + Serverpod client
    ├── vyaparsetu_ai_server/           Serverpod backend
    │   ├── lib/server.dart             Auth, web routes, cloud storage, startup
    │   ├── lib/src/endpoints/          RPC endpoints
    │   ├── lib/src/models/             `.spy.yaml` data models
    │   ├── migrations/                 Versioned SQL migrations
    │   ├── web/app/                    Hosted Flutter web build (gitignored)
    │   ├── config/                     Environment + secret configuration
    │   ├── scloud.yaml                 Serverpod Cloud project link
    │   └── Dockerfile                  Self-host fallback
    └── vyaparsetu_ai_client/           Generated Dart client (do not edit)
```

---

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| Web URL shows "Flutter web app not built" | Run `serverpod run flutter_build` from `vyaparsetu_ai/`, then `serverpod cloud deploy`. Confirm `web/app/index.html` exists. |
| `401 Unauthorized` on an API call | The endpoint requires a signed-in session. Sign in through the app; raw curl calls need the auth header. |
| OTP never arrives | Check `smtpUser` / `smtpPass`. Locally, read the code from the server console. On Cloud, verify the secrets and redeploy. |
| Database schema out of sync | `serverpod create-repair-migration`, then redeploy/restart. |
| Android blocks the APK | Allow "Install unknown apps" for the browser, then retry. |
| `docker compose` refuses to start Postgres | `.env` is missing or `VYAPARSETU_DEV_DB_PASSWORD` is empty. Re-run step 2 of local setup. |
| Port 8080/8090 already in use | Stop the other process or change ports in `config/development.yaml` and `docker-compose.yaml` together. |

---

## Notes

- The [legacy project](https://github.com/heytarshitgupta/VyaparSetu) is the design reference; this repository is the Flutter + Serverpod + PostgreSQL implementation.
- Serverpod Cloud Starter trial ends **2026-12-23**. After that the project needs a paid plan or the Dockerfile-based self-host path.
- `whatsapp.md` keeps the original migration scope notes.
