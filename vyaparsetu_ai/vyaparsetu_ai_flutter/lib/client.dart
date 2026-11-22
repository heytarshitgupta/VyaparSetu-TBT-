import 'package:vyaparsetu_ai_client/vyaparsetu_ai_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Resolves the Serverpod server URL.
/// Supports `--dart-define=SERVER_URL=https://...` for production / cloudflared tunnels,
/// falling back to assets/config.json in local development.
Future<String> resolveServerUrl() async {
  const envUrl = String.fromEnvironment('SERVER_URL');
  if (envUrl.trim().isNotEmpty) {
    var url = envUrl.trim();
    if (!url.endsWith('/')) {
      url = '$url/';
    }
    return url;
  }
  return await getServerUrl();
}

late final Client client;

Future<void> initializeClient() async {
  final url = await resolveServerUrl();
  client = Client(url)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();
}
