# VyaparSetu AI

VyaparSetu AI is a B2B marketplace for Indian artisans, producers, and buyers. The proposed HackBriven Track 2 demo uses a phone microphone and camera to draft a product listing. Buyers then discover the published listing, request a quote, and accept an offer.

The current baseline is the verified Serverpod Quickstart. Marketplace features will be built on this scaffold. The [legacy project](https://github.com/heytarshitgupta/VyaparSetu) is a design and feature reference. Reusing legacy code or assets requires rights-holder and event approval.

## Workspace

Open `vyaparsetu_ai/` in Cursor or VS Code. It contains the Flutter app (`vyaparsetu_ai_flutter`), Serverpod backend (`vyaparsetu_ai_server`), and generated Dart client (`vyaparsetu_ai_client`). Git commands work from the outer repository folder.

The baseline was verified with Flutter 3.50.1, Dart 3.14.0, and Serverpod CLI 4.1.2. Install Docker only if you are using the local development database configuration below. [Serverpod Quickstart](https://docs.serverpod.dev/quickstart)

## Run the baseline on Windows

1. From the outer repository folder, create local copies of any missing configuration files. Keep existing values when you already have a working database.

   ```powershell
   cd .\vyaparsetu_ai\vyaparsetu_ai_server
   if (-not (Test-Path -LiteralPath .env)) { Copy-Item .env.example .env }
   if (-not (Test-Path -LiteralPath config\passwords.yaml)) {
     Copy-Item config\passwords.yaml.example config\passwords.yaml
   }
   ```

2. Fill in `.env` and `config/passwords.yaml` locally. Use unique values for the database passwords, signing keys, and peppers. For random values on Windows PowerShell, run the block below once per value. Keep its output local. The four `.env` entries match the development and test `database` and `redis` entries in `passwords.yaml`.

   ```powershell
   $bytes = New-Object byte[] 32
   $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
   $rng.GetBytes($bytes)
   $rng.Dispose()
   -join ($bytes | ForEach-Object { $_.ToString('x2') })
   ```

3. Start Docker Desktop. From `vyaparsetu_ai_server/`, start the development database, then run the app from the workspace root. The setup machine can use its existing `vyaparsetu-ai-quickstart-db` container instead of starting a second database on port 8090.

   ```powershell
   docker compose up -d postgres
   cd ..
   flutter pub get
   serverpod start --no-docker
   ```

4. Open the Flutter preview URL printed by Serverpod. Enter `VyaparSetu Preview` and submit. The page should display `Hello VyaparSetu Preview`. The setup machine passed this check with the generated initial PostgreSQL migration applied. Android device verification is pending.

Keep `.env` and `config/passwords.yaml` local. Commit the example files and migrations. Use Serverpod Cloud secret storage when deployment is approved. [Serverpod configuration and secrets](https://docs.serverpod.dev/concepts/authentication/setup#storing-secrets)

## Build order

1. Verified email sign-in, buyer and producer roles, and persistent profiles.
2. Producer drafts, photo upload, publish, and live buyer catalog.
3. Buyer requests, producer quotes, quote acceptance, and persistent orders.
4. Microphone-assisted listing drafts, device verification, CI, and approved Cloud deployment.
5. Wishlist, cart, negotiation, fulfillment, notifications, multilingual features, analytics, and seller trust workflows.
