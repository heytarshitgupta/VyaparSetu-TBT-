# VyaparSetu AI

Flutter + Serverpod 4.1.2 marketplace for buyers and producers.

## Start the server

```powershell
cd vyaparsetu_ai_server
dart pub get
serverpod generate
serverpod create-migration
docker compose up -d
dart run bin/main.dart --apply-migrations
```

The API runs at `http://localhost:8080/`.

## Expose the server with Cloudflare Tunnel

```powershell
cloudflared tunnel --url http://localhost:8080
```

Use the HTTPS URL printed by Cloudflare as `SERVER_URL`.

## Run the app

```powershell
cd vyaparsetu_ai_flutter
flutter pub get
flutter run --dart-define=SERVER_URL=http://localhost:8080/
```

For a physical Android device, use the computer LAN IP:

```powershell
flutter run --dart-define=SERVER_URL=http://192.168.1.50:8080/
```

## Build the release APK

```powershell
cd vyaparsetu_ai_flutter
flutter build apk --release --dart-define=SERVER_URL=https://your-tunnel-host.trycloudflare.com/
```
