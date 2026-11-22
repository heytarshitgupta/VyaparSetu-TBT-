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

Sign-in is passwordless: the user enters an email address, receives a 6-digit OTP by email, and verifies it. In production the OTP is sent by Serverpod Cloud's transactional email service; locally it uses Gmail SMTP if configured, otherwise the code is printed to the server console.

---

## Request flows, end to end

These four traces explain the whole product. Each step names the exact file so you can answer "where is that in the code?"

### 1. "Send code" → login

1. The sign-in screen calls `startOtpLogin` (Flutter: `lib/features/auth/sign_in_screen.dart`).
2. Serverpod's email identity provider checks the email format and rate limit, creates a `EmailAccountOtpLoginRequest` row, and generates a 6-digit code.
3. The server's `sendOtpLoginVerificationCode` callback (`lib/src/auth/gmail_email_sender.dart`) sends the mail — **Serverpod Cloud email service** in production, Gmail SMTP locally.
4. You type the code → `verifyOtpLoginCode` checks it against the stored challenge.
5. A session token is issued and stored on the device. From now on every RPC carries that token.
6. The app calls `profile.getMine`. If there is no profile yet, it shows onboarding; otherwise it routes to the buyer or producer home based on `role`.

### 2. "Add Product" → live listing

1. The form (`lib/producer_section/…` product form) validates name, category, price, and optional photo.
2. `product.createDraft` inserts a `product` row with `status = draft`, owned by the caller's profile id (taken from the session, never from the client).
3. The photo is uploaded as bytes to `product_photo` after checking PNG/JPEG magic bytes and the 240 KB cap.
4. `product.publish` flips `status` to `published` **after** verifying the caller owns the row.
5. `product.catalog` returns only `published` products, which is why the buyer catalogue updates immediately.

### 3. Buyer requests a quote → producer quotes → buyer accepts

1. Buyer taps **Request quote** → `trade.requestQuote` creates one `trade_request` row: product, buyer profile, producer profile, quantity, status `requested`.
2. The producer's **Quotes** tab calls `trade.listMine`, which filters by `producerProfileId`.
3. Producer submits a total → `trade.quote` checks ownership and status (`requested` only) and stores `totalPaise`, status `quoted`.
4. Buyer taps **Accept** → `trade.accept` checks `buyerProfileId` and status (`quoted` only) and sets `accepted`.
5. Both apps read the same row, so both show the same order and amount. Invalid transitions are rejected by the server, not hidden in the UI.

### 4. Push to `main` → new APK on the same link

1. GitHub Actions starts `.github/workflows/android-apk.yml`.
2. It installs Java 21 and Flutter 3.50.1, runs `flutter pub get`.
3. `flutter build apk --release --build-number=<run number> --dart-define=SERVER_URL=<api>` produces `app-release.apk`.
4. The file is renamed `vyaparsetu.apk` and uploaded to the `apk-latest` release with `gh release upload --clobber`.
5. `https://github.com/heytarshitgupta/VyaparSetu-TBT-/releases/latest/download/vyaparsetu.apk` now serves the new file — the URL never changes, so shared links keep working.

---

## Plain-English glossary

Read this once. Every term below is used later in the README.

| Word | What it actually means here |
| --- | --- |
| **Frontend** | The screens the user sees and taps. Here: a Flutter app that runs as an Android APK **and** as a website. |
| **Backend / server** | The program that holds the rules and the data. It answers the frontend's requests. Here: a Dart program built with Serverpod. |
| **API** | The list of requests the frontend is allowed to make to the backend, e.g. "create a product", "accept a quote". |
| **RPC** | "Remote procedure call" — the frontend calls a Dart function on the server as if it were local. Serverpod generates the glue code. |
| **Endpoint** | One group of related RPC methods. `product` is an endpoint; `product.publish` is a method on it. |
| **Database** | Where data survives restarts. Here: PostgreSQL, a table-based database. |
| **Table** | One spreadsheet-like list in the database. `product` holds one row per listing. |
| **Model** | A Dart class that describes one row (and is also the shape of the JSON sent over the API). Defined in `.spy.yaml` files. |
| **Migration** | A versioned SQL script that changes the database structure (add a column, create a table). Serverpod applies them in order. |
| **Session** | A signed-in state kept on the server. The phone stores a token; the server looks up who you are on every request. |
| **OTP** | One-time password: the 6-digit code emailed to you at sign-in. No password to remember. |
| **JWT** | A signed token that proves a session is genuine. Serverpod Cloud manages the signing keys. |
| **Secret** | A password or key that must never be in git (database password, SMTP password, API key). Stored in `config/passwords.yaml` locally and as Cloud secrets in production. |
| **Environment variable** | A value passed to a program from outside the code, e.g. `SERVER_URL=https://…`. |
| **Deploy** | Ship the current code to the public server so real users get it. |
| **CI / GitHub Actions** | GitHub's robots that run commands for you on every push. Here they build the APK and publish it. |
| **Release asset** | A file attached to a GitHub Release. The APK lives there, which gives it a permanent download URL. |
| **`--dart-define`** | A build-time setting passed into a Flutter build. We use it to bake the API URL into the APK. |
| **Web build** | The same Flutter code compiled to JavaScript/WebAssembly so it runs in a browser. |
| **APK** | The installable Android app file. |
| **Paise** | 1/100 of a rupee. All money is stored as whole paise so there are no rounding errors. |
| **State machine** | A rule for which status changes are allowed: a quote can go `requested → quoted → accepted`, never backwards. |
| **Workspace / monorepo** | One repository holding several Dart packages that share dependencies (`vyaparsetu_ai/`). |
| **Serverpod Cloud** | The hosting service that runs our backend, database, web app, and Insights dashboard. |
| **Podlet** | Serverpod Cloud's name for one running copy of the backend. More podlets = more traffic capacity. |
| **Insights** | Serverpod's built-in dashboard for logs, requests, and errors of the deployed server. |

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
| **Heuristic pricing engine** | Works offline: category-based material/labour/packaging costs, a WPI-style inflation multiplier, a target margin, and a market ceiling. Every number is explainable, unlike a black-box model. |

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

1. Installs Java 21, Flutter 3.50.1, and resolves the workspace.
2. Builds `flutter build apk --release --build-number=<run number> --dart-define=SERVER_URL=<api url>`.
3. Uploads `vyaparsetu.apk` to the `apk-latest` GitHub Release with `--clobber`, and marks it the latest release.

Two build details that were needed to make CI reliable:

- **Java 21.** AGP 9's lint runs on a JDK that expects Java 21 library methods; on Java 17 the build failed inside `image_picker_android` with `NoSuchMethodError: List.removeLast()`. The workflow now pins Java 21.
- **Release lint disabled.** `android/app/build.gradle.kts` sets `lint { checkReleaseBuilds = false; abortOnError = false }`. Lint is not part of shipping an APK, and AGP 9's lint can crash on third-party plugin sources. Static analysis is still run separately with `flutter analyze`.

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

## Code map (where each feature lives)

Open the file named here when someone asks "where is that implemented?"

| Feature | Flutter (what you see) | Server (the rules) |
| --- | --- | --- |
| App start, theme, routing | `vyaparsetu_ai_flutter/lib/main.dart`, `lib/core/routes/app_router.dart` | — |
| API client and server URL | `lib/client.dart` (reads `SERVER_URL`, else the web config) | — |
| Role choice (buyer / producer) | `lib/core/auth/role_selection_screen.dart` | — |
| Email + OTP sign-in | `lib/features/auth/sign_in_screen.dart`, `lib/core/auth/auth_service.dart` | Serverpod email IDP + `lib/src/auth/gmail_email_sender.dart` |
| Profile onboarding | `lib/features/auth/profile_setup_form.dart`, `lib/producer_section/onboarding/` | `lib/src/endpoints/profile_endpoint.dart` |
| Producer home and tabs | `lib/producer_section/home/producer_main_screen.dart` | — |
| Add / edit product | `lib/producer_section/products/providers/add_product_provider.dart`, `lib/features/producer/product_drafts_screen.dart` | `lib/src/endpoints/product_endpoint.dart` |
| Product photo | `lib/features/marketplace/product_photo.dart` | `product_endpoint.dart` (magic-byte + size validation, `product_photo` table) |
| Buyer catalog and wishlist | `lib/features/marketplace/marketplace_screen.dart`, `lib/buyer_section/wishlist/wishlist_screen.dart` | `product_endpoint.dart` (`catalog`), `marketplace_extra_endpoint.dart` |
| Buyer requirements | `lib/buyer_section/post_requirement/post_requirement_screen.dart` | `marketplace_extra_endpoint.dart` |
| Quote → accept → order | `lib/features/marketplace/trades_screen.dart` | `lib/src/endpoints/trade_endpoint.dart` |
| Notifications | `lib/buyer_section/notifications/notifications_screen.dart` | `marketplace_extra_endpoint.dart` |
| AI catalog copy and price suggestion | called from the add-product form | `lib/src/endpoints/utility_endpoint.dart` |
| Database tables | — | `lib/src/models/*.spy.yaml` → `migrations/` |
| Auth, web serving, storage, seeding | — | `lib/server.dart` |

Server endpoints live in `vyaparsetu_ai_server/lib/src/endpoints/`. Each file is one endpoint group; each public method is one RPC. `vyaparsetu_ai_client/` is generated from those signatures — never edit it by hand.

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
| APK workflow fails at `lintVitalAnalyzeRelease` | AGP 9 lint crashed on a plugin (`NoSuchMethodError: List.removeLast`). The repo already pins Java 21 and disables release lint; if it returns, check those two settings first. |
| APK release step returns 403 | Settings → Actions → General → Workflow permissions must allow **Read and write**; the workflow requests `contents: write`. |
| `docker compose` refuses to start Postgres | `.env` is missing or `VYAPARSETU_DEV_DB_PASSWORD` is empty. Re-run step 2 of local setup. |
| Port 8080/8090 already in use | Stop the other process or change ports in `config/development.yaml` and `docker-compose.yaml` together. |

---

## Limitations and next steps

- Payments, escrow, and logistics are not implemented; orders are confirmed but settled offline.
- Notifications are in-app only; no FCM push or email digest yet.
- The catalog is not paginated; it is fine for a demo catalog but should be paged for thousands of listings.
- Images are stored as bytes in the database (type and size validated); production should add compression and a CDN.
- The APK is debug-signed; Play Store distribution needs a release keystore.
- OTP endpoints need per-IP rate limiting before a public launch.
