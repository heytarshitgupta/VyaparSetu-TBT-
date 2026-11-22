import 'package:flutter/foundation.dart';

class PanVerificationResult {
  const PanVerificationResult({
    required this.success,
    required this.status,
    required this.message,
    this.panLast4,
    this.maskedPan,
  });

  final bool success;
  final String status;
  final String message;
  final String? panLast4;
  final String? maskedPan;

  factory PanVerificationResult.failure(String message) =>
      PanVerificationResult(success: false, status: 'error', message: message);
}

class ProducerVerificationService {
  ProducerVerificationService();
  static ProducerVerificationService? _instance;
  static ProducerVerificationService get instance =>
      _instance ??= ProducerVerificationService();

  Future<dynamic> Function(String fnName, Map<String, dynamic> params)?
  rpcHandler;

  @visibleForTesting
  static void setMockInstance(ProducerVerificationService? mock) {
    _instance = mock;
  }

  Future<PanVerificationResult> verifyPan({
    required String pan,
    required String nameAsPerPan,
    required DateTime dateOfBirth,
  }) async {
    final clean = pan.trim().toUpperCase();
    if (clean.length != 10) {
      return PanVerificationResult.failure('Enter a valid 10-character PAN.');
    }
    return PanVerificationResult(
      success: true,
      status: 'verified',
      message: 'Verified for demo.',
      panLast4: clean.substring(6),
      maskedPan: '******${clean.substring(6)}',
    );
  }
}
