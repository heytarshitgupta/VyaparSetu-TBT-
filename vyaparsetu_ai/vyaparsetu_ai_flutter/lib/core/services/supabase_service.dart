class SupabaseService {
  SupabaseService._();
  static Future<void> initialize() async {}
  static final _LegacySupabaseClient client = _LegacySupabaseClient();
}

class _LegacySupabaseClient {
  final _LegacyAuth auth = _LegacyAuth();
}

class _LegacyAuth {
  Future<void> resetPasswordForEmail(String email) async {}
}
