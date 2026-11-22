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

## The problem and the solution

**Problem.** India's rural artisans make high-quality handcrafted goods but sell through layers of middlemen. They rarely have a digital catalog, product photos, English copy, or a way to quote bulk buyers. Buyers who want authentic handmade products cannot easily discover or verify producers.

**Solution.** VyaparSetu gives both sides one mobile-first app:

- A producer can photograph a product, dictate a description in their own words, generate catalog copy, get a price suggestion, and publish a listing in minutes.
- A buyer can search the catalog, save a wishlist, post a requirement, request a quote, and confirm the order without leaving the app.
- The quote and order history stays on one record, so both sides see the same status.

The app is built for low-end Android phones (APK), but the same Flutter code runs as a web app for buyers on desktop.

---

## What the app does

**Producers** complete a business profile, add products (photo + description, optional AI-generated catalog text), publish or hide listings, browse buyer requirements, quote a total in rupees, and see confirmed orders.

**Buyers** browse and search published products, add items to a wishlist, post requirements, request a quote, receive notifications, and accept a quote to confirm an order.

Sign-in is passwordless: the user enters an email address, receives a 6-digit OTP by Gmail SMTP, and verifies it. In local development the OTP is printed to the server console when SMTP is not configured.

---

## Five-minute demo script

1. **Open** https://vyaparsetu.serverpod.space/ and pick a role.
2. **Producer:** sign in with an email, enter the OTP, complete onboarding (business name, craft, state).
3. **Add a product:** take or choose a photo, type or dictate a description, tap **AI Generate Catalog**, optionally **Suggest Price**, then **Publish**.
4. **Buyer:** in a second browser profile or phone, sign in, browse the marketplace, open the product, add it to the wishlist, and request a quote.
5. **Producer:** open **Quotes & Orders**, submit a total in rupees.
6. **Buyer:** open **Quotes & Orders**, accept the quote. Both accounts now show the same confirmed order.
7. **Extras:** post a buyer requirement, respond to it as a producer, and show the notification feed.

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
- Product photos are stored in the `product_photo` table as validated PNG/JPEG bytes (8 bytes–240 KB). Serverpod cloud storage is configured for future media and falls back to database storage.
- Optional AI catalog generation uses `GEMINI_API_KEY` (or `LLM_API_KEY`); without a key a deterministic artisan template is used.
- OTP email delivery uses Serverpod Cloud's transactional email service in production (`scloudAuthEmailKey`, provisioned automatically). Locally it uses Gmail SMTP if configured, otherwise the code is printed in the server console. Gmail SMTP egress is blocked from Serverpod Cloud, which is why the cloud path exists.
- Demo catalog seeding runs only when `runMode == 'development'`, so production starts empty and real users onboard themselves.

---

## Design decisions (and why)

| Decision | Reason |
| --- | --- |
| **Serverpod instead of a separate REST backend** | One language (Dart) for client and server, typed RPC instead of hand-written JSON contracts, shared models, built-in auth, sessions, migrations, and one deploy for API + web. |
| **Passwordless email OTP** | Rural users should not have to remember another password. OTP avoids password storage and reset flows. Serverpod's email identity provider handles code generation and verification. |
| **Server-side sessions (30 days / 7-day inactivity)** | Mobile users stay signed in without re-entering OTPs every session; the session can be revoked server-side. |
| **Money stored as integer paise** | Avoids floating-point rounding errors in quotes and totals. The UI formats paise as ₹. |
| **Quotes and orders on one `trade_request` row** | The buyer's request, the producer's quote, and the accepted order share one id and one status machine (`requested → quoted → accepted`). No duplicate order table to reconcile. |
| **Server-side ownership checks** | Every endpoint resolves the caller's profile from the authenticated session and filters by profile id. A buyer cannot accept someone else's quote; a producer cannot edit another producer's product. |
| **Product status enum (`draft → published → hidden`)** | Hiding a product removes it from buyer search without deleting history or confirmed orders. |
| **Flutter web served by the backend** | One deploy, one origin, no CORS setup, and the web app reads the API URL from `/assets/assets/config.json` generated by the server. |
| **APK via GitHub Releases** | Serverpod Cloud artifact links expire. A GitHub Release asset at `/releases/latest/download/vyaparsetu.apk` is stable and free. |
| **AI with a deterministic fallback** | Gemini 1.5 Flash is optional (4-second timeout). If there is no key or the call fails, a local template still produces usable catalog copy, so the demo never depends on network AI. |
| **Heuristic pricing engine** | Works offline: category-based material/labour/packaging costs, a WPI-style inflation multiplier, a target margin, and a market ceiling. It is explainable to a judge, unlike a black-box model. |

---

## Data model

| Table | What it stores |
| --- | --- |
| `account_profile` | One row per authenticated user: display name, role (`buyer` / `producer`), business name, craft, city, state, verified flag. |
| `product` | Listing owned by a producer: name, description, price in paise, category, unit, MOQ, craft, location, status (`draft` / `published` / `hidden`). |
| `product_photo` | One photo per product, stored as bytes, cascade-deleted with the product. |
| `trade_request` | Buyer request + producer quote + order: product, buyer profile, producer profile, quantity, requirements, status, total in paise. |
| `buyer_requirement` | Public buyer need: title, description, category, quantity, budget, location, status. |
| `requirement_response` | A producer's response to a buyer requirement. |
| `wishlist_item` | Buyer ↔ product saved item. |
| `app_notification` | In-app notification with type, related id, read flag. |

Indexes cover the foreign keys used by the main lists: products by producer, trades by buyer and producer, profiles by auth user (unique), photos by product (unique).

---

## Security model

- **Authentication:** Serverpod email IDP with 6-digit OTPs; server-side sessions; JWT keys and email pepper are platform-managed on Serverpod Cloud.
- **Secrets:** `config/passwords.yaml` is gitignored locally; in the cloud they are stored with `serverpod cloud password set` and injected as `SERVERPOD_PASSWORD_*` environment variables.
- **Authorization:** endpoints never trust ids from the client. They load the caller's `account_profile` from the session and check ownership before reads or writes. State transitions (`publish`, `hide`, `quote`, `accept`) are validated on the server.
- **Transport:** HTTPS everywhere on Serverpod Cloud; the Flutter client talks only to the API origin.
- **Input handling:** typed models and generated serialization reject malformed payloads; money is an integer; SQL is parameterized by Serverpod's ORM. Uploaded photos are checked for PNG/JPEG magic bytes and capped at 240 KB.
- **Known hardening work:** per-IP rate limiting on OTP requests and audit logging for admin actions.

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
| `SMTP_USER` / `SMTP_PASS` | Local/self-host Gmail sender. Not reachable from Serverpod Cloud. |
| `scloudAuthEmailKey` | Serverpod Cloud transactional email token, provisioned automatically and used for production OTP delivery. |
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

Serverpod Cloud manages `database`, `serviceSecret`, `emailSecretHashPepper`, JWT keys, `scloudAuthEmailKey`, and the Cloud email key automatically. Re-deploy after changing a secret.

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
| OTP never arrives | Locally, read the code from the server console or set `smtpUser` / `smtpPass`. On Cloud, OTPs go through Serverpod Cloud's email service; check `serverpod cloud log` for `Failed to send ... email via the Serverpod Cloud email service`. |
| Send code spins for a minute then returns | This was the old Gmail SMTP path timing out from Serverpod Cloud. The server now uses the platform email service; redeploy if you see this. |
| Database schema out of sync | `serverpod create-repair-migration`, then redeploy/restart. |
| Android blocks the APK | Allow "Install unknown apps" for the browser, then retry. |
| `docker compose` refuses to start Postgres | `.env` is missing or `VYAPARSETU_DEV_DB_PASSWORD` is empty. Re-run step 2 of local setup. |
| Port 8080/8090 already in use | Stop the other process or change ports in `config/development.yaml` and `docker-compose.yaml` together. |

---

## Mentor Q&A

**What exactly is the product?**
A mobile-first B2B marketplace that lets rural artisans create a product catalog and quote bulk buyers, and lets buyers discover, request, and confirm orders in one place.

**Who is the user and why would they use it?**
Producers in craft clusters (handloom, terracotta, brass, woodcraft, food) who sell through middlemen, and bulk buyers (retailers, exporters, gifting companies) who want authentic handmade supply. Producers get reach and pricing help; buyers get discovery and a structured quote flow.

**Why not just use WhatsApp or IndiaMART?**
WhatsApp has no catalog, quote state, or order record. IndiaMART is lead-generation and paid. VyaparSetu is purpose-built for artisans: voice-assisted listing, AI catalog copy, a price floor recommendation, and a simple quote → accept workflow.

**What is technically interesting here?**
End-to-end Dart with Serverpod: one set of models generates the database schema, server stubs, and typed client. The same codebase serves Android, web, API, and the web frontend. Auth, sessions, migrations, and cloud storage are integrated instead of stitched together.

**How does authentication work?**
Email + 6-digit OTP through Serverpod's email identity provider. The server issues a server-side session (30-day lifetime, 7-day inactivity timeout). No passwords are stored. On the cloud, SMTP credentials and the session pepper are project secrets.

**How do you stop a buyer from accepting someone else's quote?**
The `accept` endpoint loads the trade by id and checks `buyerProfileId` against the caller's profile from the session. The same pattern protects product edits, publishing, and producer quotes.

**How is money handled?**
All amounts are integers in paise (`pricePaise`, `budgetPaise`, `totalPaise`). The UI formats them as ₹. This avoids floating-point errors and keeps the database representation exact.

**What happens if the AI key is missing or Gemini is slow?**
The AI call is optional and has a 4-second timeout. On any failure, `generateCatalogDescription` returns a deterministic artisan template. The pricing engine is entirely local, so the core demo works offline.

**How does the price suggestion work?**
It estimates material cost, quantity, labour hours and wage, packaging, and a target margin by category, applies a WPI-style inflation multiplier, computes a break-even floor, and clamps the recommendation between the floor and a market ceiling. Bulk mode uses a thinner wholesale margin.

**How is the app deployed?**
Serverpod Cloud runs a monolith role: API, web server, and Insights in one project with managed PostgreSQL. `serverpod cloud deploy` builds the server, applies migrations, and rolls out. The Flutter web build is copied into `web/app` and served by the same backend.

**How do users get updates?**
Every push to `main` triggers GitHub Actions, builds a release APK with an incrementing build number, and replaces the asset in the `apk-latest` release. The `/releases/latest/download/vyaparsetu.apk` link never changes.

**What about scale?**
The API is stateless and can run multiple podlets; the database is managed and indexed on the main access paths. The monolith role can be split into separate API, web, and Insights roles. The next bottlenecks are image storage and catalog pagination, both straightforward to add.

**What did you test?**
`dart analyze`, `flutter test`, `dart test` (embedded PostgreSQL), plus a manual two-account end-to-end run: producer publishes a product, buyer requests a quote, producer quotes, buyer accepts, both sides see the confirmed order.

**What is not built yet?**
Payments/escrow, shipping and logistics, ratings, push notifications, real-time chat, GST invoicing, regional-language UI, and Play Store signing. The current release is a working marketplace core, not a finished commercial platform.

**Why does production start with an empty database?**
Seeding is development-only on purpose: a real deployment should not contain fake producers. For a demo, create a producer account and add products live, or run the development seed against a staging database.

---

## Limitations and next steps

- Payments, escrow, and logistics are not implemented; orders are confirmed but settled offline.
- Notifications are in-app only; no FCM push or email digest yet.
- The catalog is not paginated; it is fine for a demo catalog but should be paged for thousands of listings.
- Images are stored as bytes in the database (type and size validated); production should add compression and a CDN.
- The APK is debug-signed; Play Store distribution needs a release keystore.
- OTP endpoints need per-IP rate limiting before a public launch.

---

## Notes

- The [legacy project](https://github.com/heytarshitgupta/VyaparSetu) is the design reference; this repository is the Flutter + Serverpod + PostgreSQL implementation.
- Serverpod Cloud Starter trial ends **2026-12-23**. After that the project needs a paid plan or the Dockerfile-based self-host path.
- `whatsapp.md` keeps the original migration scope notes.
