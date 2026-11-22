import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

class ProfileEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Future<AccountProfile?> getMine(Session session) {
    final authUserId = session.authenticated!.authUserId;
    return AccountProfile.db.findFirstRow(
      session,
      where: (profile) => profile.authUserId.equals(authUserId),
    );
  }

  Future<AccountProfile> completeOnboarding(
    Session session, {
    required String displayName,
    required MarketplaceRole role,
    String? businessName,
    String? craftCategory,
    String? city,
    String? state,
    String? address,
  }) async {
    final name = displayName.trim();
    if (name.isEmpty || name.runes.length > 80) {
      throw ProfileException(message: 'Enter a name of 1 to 80 characters.');
    }

    final existing = await getMine(session);
    if (existing != null) {
      final checked = _checkRole(existing, role);
      if (role == MarketplaceRole.producer) {
        checked.businessName = businessName?.trim();
        checked.craftCategory = craftCategory?.trim();
        checked.city = city?.trim();
        checked.state = state?.trim();
        checked.address = address?.trim();
        checked.verified = true;
        return AccountProfile.db.updateRow(session, checked);
      }
      return checked;
    }

    try {
      return await AccountProfile.db.insertRow(
        session,
        AccountProfile(
          authUserId: session.authenticated!.authUserId,
          displayName: name,
          role: role,
          businessName: businessName?.trim(),
          craftCategory: craftCategory?.trim(),
          city: city?.trim(),
          state: state?.trim(),
          address: address?.trim(),
          verified: true,
        ),
      );
    } on DatabaseUniqueViolationException {
      // An overlapping request may already have created this user's profile.
      final saved = await getMine(session);
      if (saved == null) rethrow;
      return _checkRole(saved, role);
    }
  }

  AccountProfile _checkRole(AccountProfile profile, MarketplaceRole role) {
    if (profile.role != role) {
      throw ProfileException(message: 'This account already has a role.');
    }
    return profile;
  }

  Future<bool> verifyProducerPan(
    Session session, {
    required String panNumber,
  }) async {
    final cleanPan = panNumber.trim().toUpperCase();
    final isValid = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(cleanPan);
    if (!isValid) {
      throw ProfileException(message: 'Invalid PAN format. Example format: ABCDE1234F');
    }
    final profile = await requireMarketplaceProfile(session, MarketplaceRole.producer);
    profile.verified = true;
    await AccountProfile.db.updateRow(session, profile);
    return true;
  }
}

Future<AccountProfile> requireMarketplaceProfile(
  Session session,
  MarketplaceRole role,
) async {
  final profile = await ProfileEndpoint().getMine(session);
  if (profile == null || profile.role != role) {
    throw ProductDraftException(
      message: role == MarketplaceRole.producer
          ? 'A Producer profile is required.'
          : 'A Buyer profile is required.',
    );
  }
  return profile;
}
