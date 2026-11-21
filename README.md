# VyaparSetu AI

VyaparSetu AI is a B2B marketplace for Indian artisans, producers, and buyers. The proposed HackBriven Track 2 demo uses a phone microphone and camera to draft a product listing. Buyers then discover the published listing, request a quote, and accept an offer.

This is the new [hackathon repository](https://github.com/heytarshitgupta/VyaparSetu-TBT-). The [legacy project](https://github.com/heytarshitgupta/VyaparSetu) is the design and feature reference. Reusing legacy code or assets requires rights-holder and event approval.

## Start here

**Latest checkpoint: PROD-01A.** The app has real email-code sign-in and saves a Buyer or Producer profile, and producers can save and view private product drafts with database persistence and role isolation. Product photos, publish, catalog search, quotes, orders, and voice input are future tasks.

**Current team assignment:** [whatsapp.md](whatsapp.md) has the active task, starter code, tests, and commit instructions. Pull updated `main` before opening it.

### Open the app on the setup laptop

Start Docker Desktop, then run these commands in **PowerShell** on the setup laptop. Keep the last command running. Click the **Flutter preview URL** printed in the terminal. The port can change after a restart.

```powershell
cd C:\Users\Lenovo\PERSONAL\VyaparSetu\vyaparsetu_ai
docker start vyaparsetu-ai-quickstart-db
serverpod start --no-docker
```

| What you want to see | Where to look |
| --- | --- |
| Actual app | The Flutter preview URL in the Serverpod terminal, usually `http://localhost:<port>`. Open it in Chrome. |
| Backend | Serverpod listens at `http://localhost:8080` with the default local config. The app calls it automatically. |
| Database | Local PostgreSQL on port `8090`. Reloading **My Products** shows drafts read from that database. |
| Public web or phone app | Cloud deployment and Android device verification are pending. `localhost` opens only on the computer running the app. |

### Check AUTH-01 yourself

1. On the app's sign-in screen, enter a test-only email and request a code. Get that code from the **local Serverpod terminal**. Development codes appear there. Keep them out of messages, screenshots, and Git.
2. Complete registration if prompted. Enter a display name, choose **Buyer**, then click **Save profile**. Expect **Buyer workspace** and your display name.
3. Sign out and sign in again with the same email. Expect the same workspace and name without repeating onboarding. Repeat with a different test email and choose **Producer** to see **Producer workspace**.

### Check PROD-01A yourself

1. Sign in to a test Producer account (or register one by selecting **Producer** during onboarding).
2. On the **Producer workspace**, click **My Products**.
3. Under **New draft**, enter a product name (e.g. `Copper Bottle`) and optional description (e.g. `Handcrafted pure copper water bottle`), then click **Save draft**.
4. Confirm the record appears under **Saved drafts** with status `draft`.
5. Reload/reopen the screen to confirm the draft persists from the database.
6. Sign into another test Producer account and confirm the first producer's draft does not appear there.
7. Sign into a Buyer account and confirm there is no **My Products** button, and buyer draft access is rejected by the server.

Use `Ctrl+C` or the runner's `Q` option when you are done with the preview. You can try this screen at any time while the local stack is running.

## Workspace

Open `vyaparsetu_ai/` in Cursor or VS Code. It contains the Flutter app (`vyaparsetu_ai_flutter`), Serverpod backend (`vyaparsetu_ai_server`), and generated Dart client (`vyaparsetu_ai_client`). Git commands work from the outer repository folder.

The baseline was verified with Flutter 3.50.1, Dart 3.14.0, and Serverpod CLI 4.1.2. Install Docker only if you are using the local development database configuration below. [Serverpod Quickstart](https://docs.serverpod.dev/quickstart)

## First-time setup for a teammate on Windows

1. Install Git, Flutter, the Serverpod 4 CLI, and Docker Desktop if they are missing. Start Docker Desktop. Clone and open the server folder. [Serverpod Quickstart](https://docs.serverpod.dev/quickstart)

   ```powershell
   git clone https://github.com/heytarshitgupta/VyaparSetu-TBT-.git
   cd .\VyaparSetu-TBT-\vyaparsetu_ai\vyaparsetu_ai_server
   ```

2. On a **fresh clone**, paste this block into PowerShell from the server folder. It generates matching local credentials and saves them privately. If both files already exist and your database works, skip this step. Existing quickstart setups also need a local `serverSideSessionKeyHashPepper` under development and test.

   ```powershell
   if ((Test-Path .env) -or (Test-Path config\passwords.yaml)) {
     throw 'Local configuration already exists. Keep its credentials and use the run step below.'
   }
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

3. Start Docker Desktop. From `vyaparsetu_ai_server/`, start the development database, then run the app from the workspace root. The setup machine can use its existing `vyaparsetu-ai-quickstart-db` container instead of starting a second database on port 8090.

   ```powershell
   docker compose up -d postgres
   cd ..
   flutter pub get
   serverpod start --no-docker
   ```

4. Open the **Flutter preview URL** printed by Serverpod. Try **Producer → My Products → New draft → Save draft** using the walkthrough above. On later runs use step 3 with the saved credentials. Run `flutter pub get` again when dependency files change.

Keep `.env` and `config/passwords.yaml` local. Commit the example files and migrations. A Cloud deployment needs its own `serverSideSessionKeyHashPepper`. [Serverpod configuration and secrets](https://docs.serverpod.dev/concepts/authentication/setup#storing-secrets)

## Save and share a checkpoint

A commit saves a snapshot on your laptop. A push uploads that branch to GitHub. A pull request lets the team review it before it becomes part of `main`.

Use the branch name, file list, tests, and commit message in [whatsapp.md](whatsapp.md). On GitHub, open **Compare & pull request** and choose `main` as the base. After review and merge, the coordinator updates the assignment before the next contributor branches from `main`.

### Optional automated checks

The browser walkthrough is the quickest way to see the app running. Automated checks are mainly for the contributor before opening a PR. The first run on a machine can take longer while Flutter resolves packages and compiles the test runner or Docker fetches its database image. Start with the test for the feature you changed. Share the slow step or error if a command stalls.

To run just the product-draft widget tests from the outer repo folder:

```powershell
cd .\vyaparsetu_ai\vyaparsetu_ai_flutter
flutter test --no-pub test/product_drafts_screen_test.dart
```

To rerun the server tests in a separate PowerShell terminal from the outer repo folder on Windows, use the test Compose database. Set up matching test credentials first, as described above.

```powershell
cd .\vyaparsetu_ai\vyaparsetu_ai_server
docker compose up -d postgres_test
$env:SERVERPOD_DATABASE_DATA_PATH = ' '
$env:SERVERPOD_DATABASE_HOST = '127.0.0.1'
$env:SERVERPOD_DATABASE_PORT = '9090'
dart test test/integration/product_drafts_test.dart
docker compose stop postgres_test
```

Close the test terminal afterward to clear its environment variables.

## Team build order

| Checkpoint | Owner | What the team will verify |
| --- | --- | --- |
| SETUP-00 | Coordinator | Flutter preview could call the local Serverpod backend. On `main`. |
| AUTH-01 | MEMBER_1 (coordinator) | Sign in, choose a role, and reload the saved profile. On `main`. |
| PROD-01A | MEMBER_3 | Save and view private product drafts. Merged into `main` in PR #1. |
| PROD-01B | MEMBER_2 | Add publish and hide controls with server-side owner checks. See [whatsapp.md](whatsapp.md). |
| CAT-01 / MEDIA-01 | Assigned in the next handoff | Buyer catalog and product photos follow publishing. |
| TRADE-01 | MEMBER_4 | A buyer requests a quote, a producer responds, and acceptance creates one order. |
| AI-01 / QA-01 | MEMBER_5 | Draft a listing from speech, verify the phone demo and CI, and prepare approved Cloud deployment. |

MEMBER_1 coordinates reviews and updates [whatsapp.md](whatsapp.md) after each merge. Each assigned contributor works on a branch from updated `main`, implements and tests their changes, commits under their own account, and opens a PR.

After the core demo, the backlog includes wishlist, cart, negotiation, fulfillment, notifications, multilingual support, photo enhancement, pricing, analytics, and seller verification.

For each merged milestone, update this README with its status, exact run commands, a short click-through check, and who owns the next task.
