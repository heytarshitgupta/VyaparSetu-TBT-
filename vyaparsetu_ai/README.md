# VyaparSetu AI — workspace

Dart/Flutter workspace for the VyaparSetu marketplace. Live URLs, APK download, local setup, and deployment steps are in the [root README](../README.md).

## Packages

| Package | Purpose |
| --- | --- |
| `vyaparsetu_ai_flutter` | Flutter app (buyer + producer, Android + web) |
| `vyaparsetu_ai_server` | Serverpod backend, migrations, hosted web build |
| `vyaparsetu_ai_client` | Generated Dart client — do not edit |

## Backend notes

- Local config: `vyaparsetu_ai_server/config/development.yaml`; `production.yaml` is managed by Serverpod Cloud.
- Local secrets: `config/passwords.yaml`. Cloud secrets: `serverpod cloud password set <name> <value>`.
- Migrations: run `serverpod create-migration` after model changes; the runner applies pending migrations on boot.
- Generated code lives in `vyaparsetu_ai_server/lib/src/generated/` and `vyaparsetu_ai_client/`. Never edit it by hand.
- Local database: `docker compose up -d postgres` from `vyaparsetu_ai_server` (port 8090).

## Checks

```powershell
dart analyze
cd vyaparsetu_ai_flutter; flutter test
cd ..\vyaparsetu_ai_server; dart test
```
