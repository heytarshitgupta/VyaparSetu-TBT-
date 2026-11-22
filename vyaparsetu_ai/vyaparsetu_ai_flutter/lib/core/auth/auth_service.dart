enum OtpType { signup, recovery, magiclink, sms, email }

enum OtpChannel { sms, whatsapp }

class AuthException implements Exception {
  AuthException(this.message, {this.statusCode});
  final String message;
  final String? statusCode;
}

class MockUser {
  MockUser({required this.id, this.email, this.phone, this.userMetadata});
  final String id;
  final String? email;
  final String? phone;
  final Map<String, dynamic>? userMetadata;
}

class MockSession {
  MockSession({required this.accessToken});
  final String accessToken;
}

class AuthResponse {
  AuthResponse({this.session, this.user});
  final MockSession? session;
  final MockUser? user;
}

class UserResponse {
  UserResponse({this.user});
  final MockUser? user;
}

class UserAttributes {
  UserAttributes({this.password});
  final String? password;
}

class ResendResponse {
  const ResendResponse();
}

class AuthConstants {
  static const int otpLength = 6;
  static const int emailOtpCooldownSeconds = 60;
  static const int otpResendCooldownSeconds = 60;
  static const int otpValidityMinutes = 10;
}

class PostgrestException implements Exception {
  PostgrestException(this.message, {this.code, this.hint, this.details});
  final String message;
  final String? code;
  final String? hint;
  final dynamic details;
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  MockUser? get currentUser => _user;
  MockSession? get currentSession => _session;
  Stream<Object> get authStateChanges => const Stream<Object>.empty();
  MockUser? _user;
  MockSession? _session;

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    _user = MockUser(id: 'mock-user', email: email, userMetadata: data);
    _session = MockSession(accessToken: 'mock-token');
    return AuthResponse(session: _session, user: _user);
  }

  Future<AuthResponse> signUpWithPhone({
    required String phone,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    _user = MockUser(id: 'mock-user', phone: phone, userMetadata: data);
    _session = MockSession(accessToken: 'mock-token');
    return AuthResponse(session: _session, user: _user);
  }

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _user = MockUser(id: 'mock-user', email: email);
    _session = MockSession(accessToken: 'mock-token');
    return AuthResponse(session: _session, user: _user);
  }

  Future<void> signOut() async {
    _user = null;
    _session = null;
  }

  Future<void> sendPhoneOtp(String phone) async {}
  Future<void> sendWhatsAppOtp(String phone) async {}
  Future<AuthResponse> verifyPhoneOtp({
    required String phone,
    required String otp,
  }) async =>
      signInWithEmail(email: '$phone@phone.vyaparsetu.local', password: otp);
  Future<void> sendEmailOtp(String email) async {}
  Future<void> sendPasswordResetOtp(String email) async {}
  Future<AuthResponse> verifyEmailOtp({
    required String email,
    required String otp,
    OtpType type = OtpType.email,
  }) async => signInWithEmail(email: email, password: otp);
  Future<UserResponse> updatePassword({required String newPassword}) async =>
      UserResponse(user: currentUser);
  Future<AuthResponse> signInWithEmailOtp({required String email}) async =>
      signInWithEmail(email: email, password: 'otp');
  Future<AuthResponse> verifyEmailLoginOtp({
    required String email,
    required String otp,
  }) async => signInWithEmail(email: email, password: otp);
  Future<void> sendPasswordRecoveryOtp({required String email}) async {}
  Future<AuthResponse> verifyRecoveryOtp({
    required String email,
    required String otp,
  }) async => signInWithEmail(email: email, password: otp);
  Future<ResendResponse> resendEmailOtp({
    required String email,
    OtpType? type,
  }) async => const ResendResponse();
}

typedef User = MockUser;
