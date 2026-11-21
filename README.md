# VyaparSetu AI

VyaparSetu AI is a B2B marketplace for Indian artisans, producers, and buyers. The proposed HackBriven Track 2 demo uses a phone microphone and camera to draft a product listing. Buyers then discover the published listing, request a quote, and accept an offer.

This is the new [hackathon repository](https://github.com/heytarshitgupta/VyaparSetu-TBT-). The [legacy project](https://github.com/heytarshitgupta/VyaparSetu) is the design and feature reference. Reusing legacy code or assets requires rights-holder and event approval.

## Start here

**Latest checkpoint: AUTH-01.** The app has real email-code sign-in and saves a Buyer or Producer profile. The role-specific workspace currently shows a welcome screen. Product listings, search, quotes, orders, and voice input are future tasks.

**Current team assignment:** [whatsapp.md](whatsapp.md) has the active task, starter code, tests, and commit instructions. Pull updated `main` before opening it.

### Open the app on the setup laptop

If the preview is already running, open [localhost:53075](http://localhost:53075/). If it does not open, start Docker Desktop, then run the following in **PowerShell**. Keep the last command running and use the Flutter preview address it prints. The port may change after a restart.

```powershell
cd C:\Users\Lenovo\PERSONAL\VyaparSetu\vyaparsetu_ai
docker start vyaparsetu-ai-quickstart-db
flutter pub get
serverpod start --no-docker
```

### Check AUTH-01 yourself

1. On the app's sign-in screen, enter a test-only email and request a code. Get that code from the **local Serverpod terminal**. Development codes appear there. Keep them out of messages, screenshots, and Git.
2. Complete registration if prompted. Enter a display name, choose **Buyer**, then click **Save profile**. Expect **Buyer workspace** and your display name.
3. Sign out and sign in again with the same email. Expect the same workspace and name without repeating onboarding. Repeat with a different test email and choose **Producer** to see **Producer workspace**.

Use `Ctrl+C` or the runner's `Q` option when you are done with the preview. Five server integration tests and two Flutter widget tests passed for this checkpoint. Cloud email delivery and Android device testing are pending.

## Workspace

Open `vyaparsetu_ai/` in Cursor or VS Code. It contains the Flutter app (`vyaparsetu_ai_flutter`), Serverpod backend (`vyaparsetu_ai_server`), and generated Dart client (`vyaparsetu_ai_client`). Git commands work from the outer repository folder.

The baseline was verified with Flutter 3.50.1, Dart 3.14.0, and Serverpod CLI 4.1.2. Install Docker only if you are using the local development database configuration below. [Serverpod Quickstart](https://docs.serverpod.dev/quickstart)

## First-time setup for a teammate on Windows

1. From the outer repository folder, create local copies of any missing configuration files. Keep existing values when you already have a working database.

   ```powershell
   cd .\vyaparsetu_ai\vyaparsetu_ai_server
   if (-not (Test-Path -LiteralPath .env)) { Copy-Item .env.example .env }
   if (-not (Test-Path -LiteralPath config\passwords.yaml)) {
     Copy-Item config\passwords.yaml.example config\passwords.yaml
   }
   ```

2. Fill in `.env` and `config/passwords.yaml` locally. If you already ran Quickstart, add `serverSideSessionKeyHashPepper` under `development` and `test` with different values. For a random value on Windows PowerShell, run the block below once per value. Keep its output local. The four `.env` entries match the development and test `database` and `redis` entries in `passwords.yaml`.

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

4. Open the Flutter preview URL printed by Serverpod and follow **Check AUTH-01 yourself** above.

Keep `.env` and `config/passwords.yaml` local. Commit the example files and migrations. A Cloud deployment needs its own `serverSideSessionKeyHashPepper`. [Serverpod configuration and secrets](https://docs.serverpod.dev/concepts/authentication/setup#storing-secrets)

## Save and share a checkpoint

A commit saves a snapshot on your laptop. A push uploads that branch to GitHub. A pull request lets the team review it before it becomes part of `main`.

Use the branch name, file list, tests, and commit message in [whatsapp.md](whatsapp.md). On GitHub, open **Compare & pull request** and choose `main` as the base. After review and merge, the coordinator updates the assignment before the next contributor branches from `main`.

To rerun the Flutter tests from the outer repo folder:

```powershell
cd .\vyaparsetu_ai\vyaparsetu_ai_flutter
flutter test --no-pub test/profile_setup_form_test.dart
```

To rerun the server tests in a separate PowerShell terminal from the outer repo folder on Windows, use the test Compose database. Set up matching test credentials first, as described above.

```powershell
cd .\vyaparsetu_ai\vyaparsetu_ai_server
docker compose up -d postgres_test
$env:SERVERPOD_DATABASE_DATA_PATH = ' '
$env:SERVERPOD_DATABASE_HOST = '127.0.0.1'
$env:SERVERPOD_DATABASE_PORT = '9090'
dart test test/integration/profile_test.dart test/integration/greeting_endpoint_test.dart
docker compose stop postgres_test
```

Close the test terminal afterward to clear its environment variables.

## Team build order

| Checkpoint | Owner | What the team will verify |
| --- | --- | --- |
| SETUP-00 | Coordinator | Flutter preview could call the local Serverpod backend. On `main`. |
| AUTH-01 | MEMBER_1 (coordinator) | Sign in, choose a role, and reload the saved profile. On `main`. |
| PROD-01A / PROD-01B | MEMBER_3 | First save and view private drafts. Then add photo upload, publish, and hide in a separate PR. |
| CAT-01 | MEMBER_2 | A buyer can find the producer's published listing in the real catalog. |
| TRADE-01 | MEMBER_4 | A buyer requests a quote, a producer responds, and acceptance creates one order. |
| AI-01 / QA-01 | MEMBER_5 | Draft a listing from speech, verify the phone demo and CI, and prepare approved Cloud deployment. |

MEMBER_1 coordinates reviews and updates [whatsapp.md](whatsapp.md) after each merge. Each assigned contributor works on a branch from updated `main`, implements and tests their changes, commits under their own account, and opens a PR.

After the core demo, the backlog includes wishlist, cart, negotiation, fulfillment, notifications, multilingual support, photo enhancement, pricing, analytics, and seller verification.

For each merged milestone, update this README with its status, exact run commands, a short click-through check, and who owns the next task.
