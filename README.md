# VyaparSetu AI

VyaparSetu AI is a B2B marketplace for Indian artisans, producers, and buyers. The proposed HackBriven Track 2 demo uses a phone microphone and camera to draft a product listing. Buyers then discover the published listing, request a quote, and accept an offer.

The [legacy project](https://github.com/heytarshitgupta/VyaparSetu) is the design and feature reference. This branch implements the marketplace flows on the new Flutter, Serverpod and PostgreSQL stack. Check the event’s reuse rules before importing legacy source or assets.

## Run the marketplace

From `vyaparsetu_ai/`, with the configured local PostgreSQL instance running, use `flutter pub get` and `serverpod start --no-docker`. Open the Flutter preview URL printed by the runner. On an existing database, apply the committed migrations before using the new features. Once the runner is up, press **M** to apply them if pending.

| What you want to see | Where to look |
| --- | --- |
| Flutter app | The preview URL printed by the Serverpod runner. |
| Serverpod API | `http://localhost:8080` with the checked-in development configuration. |
| PostgreSQL | `localhost:8090` with the checked-in development configuration. |

### Demo walkthrough

1. Sign in with a test Producer account. In local development, read the one-time code from the Serverpod terminal. Complete the Producer profile if prompted.
2. Open **My Products**. Enter a name, dictate or type a description, and take or choose a product photo. Save the draft, then publish it.
3. In a separate browser profile or device, sign in as a Buyer. Open **Browse marketplace**, search for the product, open it, and request a quote. For example, enter 50 bags, two colours, and a delivery deadline.
4. On the Producer account, open **Quotes and orders**, refresh if needed, and submit a total in rupees.
5. On the Buyer account, open **Quotes and orders**, refresh if needed, and confirm the quote. Both accounts can see the same order number.
6. Hide the listing from **My Products**. It disappears from buyer search, and the confirmed order remains visible to both parties.

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

4. Open the **Flutter preview URL** printed by Serverpod. Run the buyer and producer walkthrough above. On later runs use step 3 with the saved credentials. Run `flutter pub get` again when dependency files change.

Keep `.env` and `config/passwords.yaml` local. Commit the example files and migrations. A Cloud deployment needs its own `serverSideSessionKeyHashPepper`. [Serverpod configuration and secrets](https://docs.serverpod.dev/concepts/authentication/setup#storing-secrets)

## Checks and release

From `vyaparsetu_ai/`, run `dart analyze`. Run `flutter test` in `vyaparsetu_ai_flutter/` and `dart test` in `vyaparsetu_ai_server/`. The test server uses its own embedded PostgreSQL by default. If embedded PostgreSQL fails on Windows, use the isolated test database from the server package with the matching credentials from setup.

```powershell
docker compose up -d postgres_test
$env:SERVERPOD_DATABASE_DATA_PATH = ' '
$env:SERVERPOD_DATABASE_HOST = '127.0.0.1'
$env:SERVERPOD_DATABASE_PORT = '9090'
dart test
docker compose stop postgres_test
```

Close the test shell to clear those environment overrides.

Run `flutter build web --release` in the Flutter package to produce the release web bundle. For Serverpod Cloud, run the configured `serverpod run flutter_build` script and follow the [deployment guide](https://docs.serverpod.dev/deployments/deploy-to-serverpod-cloud). Use the actual HTTPS API URL from the deployment for native releases, passed as `--dart-define=SERVER_URL=https://<api-host>/`. Verify real email delivery, the two-account walkthrough, and camera and microphone permissions on the target device.

[whatsapp.md](whatsapp.md) records the migration scope and outstanding work.
