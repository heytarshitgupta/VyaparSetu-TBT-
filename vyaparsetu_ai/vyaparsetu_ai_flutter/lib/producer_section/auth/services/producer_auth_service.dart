enum ProducerAuthStatus {
  success,
  buyerRejected,
  adminRejected,
  incompleteSetup,
  error,
}

class ProducerAuthValidationResult {
  const ProducerAuthValidationResult({
    required this.status,
    required this.message,
    this.profile,
    this.producerProfile,
  });

  final ProducerAuthStatus status;
  final String message;
  final Map<String, dynamic>? profile;
  final Map<String, dynamic>? producerProfile;
  bool get isSuccess => status == ProducerAuthStatus.success;
}

class ProducerAuthService {
  ProducerAuthService._();
  static final ProducerAuthService instance = ProducerAuthService._();

  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _producerProfile;

  Future<String> registerProducerProfile({required String fullName}) async {
    _profile = {'full_name': fullName.trim(), 'role': 'producer'};
    _producerProfile ??= {
      'business_name': '',
      'craft_category': '',
      'onboarding_step': 1,
    };
    return 'ok';
  }

  Future<Map<String, dynamic>?> fetchProfile() async => _profile;
  Future<Map<String, dynamic>?> fetchProducerProfile() async =>
      _producerProfile;

  Future<void> updateBasicProfile({
    required String fullName,
    String? phone,
  }) async {
    _profile = {
      ...?_profile,
      'full_name': fullName.trim(),
      if (phone != null) 'phone': phone.trim(),
    };
  }

  Future<void> updateBusinessProfile({
    required String businessName,
    required String craftCategory,
    String? bio,
  }) async {
    _producerProfile = {
      ...?_producerProfile,
      'business_name': businessName.trim(),
      'craft_category': craftCategory.trim(),
      'bio': bio,
    };
  }

  Future<void> updateLocationProfile({
    required String state,
    required String district,
    required String city,
    required String pincode,
    required String address,
  }) async {
    _producerProfile = {
      ...?_producerProfile,
      'state': state.trim(),
      'district': district.trim(),
      'city': city.trim(),
      'pincode': pincode.trim(),
      'address': address.trim(),
    };
  }

  Future<void> advanceOnboardingStep({
    required int expectedCurrentStep,
    required int nextStep,
  }) async {
    _producerProfile = {...?_producerProfile, 'onboarding_step': nextStep};
  }

  Future<ProducerAuthValidationResult> validateProducerAccess({
    String? fallbackFullName,
  }) async {
    await registerProducerProfile(
      fullName: fallbackFullName?.trim().isNotEmpty == true
          ? fallbackFullName!
          : 'Producer',
    );
    return ProducerAuthValidationResult(
      status: ProducerAuthStatus.success,
      message: 'Producer access ready.',
      profile: _profile,
      producerProfile: _producerProfile,
    );
  }
}
