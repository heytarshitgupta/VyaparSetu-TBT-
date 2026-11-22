/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:vyaparsetu_ai_client/src/protocol/account_profile.dart'
    as _i8viowtb;
import 'package:vyaparsetu_ai_client/src/protocol/app_notification.dart'
    as _iyi705kw;
import 'package:vyaparsetu_ai_client/src/protocol/buyer_requirement.dart'
    as _izbpoeda;
import 'package:vyaparsetu_ai_client/src/protocol/greetings/greeting.dart'
    as _i6ek115x;
import 'package:vyaparsetu_ai_client/src/protocol/marketplace_role.dart'
    as _ibpr19yd;
import 'package:vyaparsetu_ai_client/src/protocol/product.dart' as _idm7l56a;
import 'package:vyaparsetu_ai_client/src/protocol/requirement_response.dart'
    as _itzn3mk3;
import 'package:vyaparsetu_ai_client/src/protocol/trade_request.dart'
    as _ir66x6wy;
import 'package:vyaparsetu_ai_client/src/protocol/wishlist_item.dart'
    as _i0vcfhnc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailOtpIdpBaseEndpoint], the email identity provider
/// endpoints, including the passwordless sign-in with one-time passwords, are
/// made available on the server and enable the corresponding sign-in widget on
/// the client.
///
/// Extend [EmailIdpBaseEndpoint] instead for the password based sign-in only.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailOtpIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Starts a passwordless login by sending a one-time password to [email].
  ///
  /// The code is sent whether or not an account is registered for the email.
  /// If none is, verifying the code lets the user create a new account.
  ///
  /// Always returns a login request ID, which must be passed to
  /// [verifyOtpLoginCode] together with the one-time password.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the email is
  ///   not valid.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if too many
  ///   one-time passwords have been requested for the email.
  @override
  _ida.Future<_isc.UuidValue> startOtpLogin({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startOtpLogin',
        {'email': email},
      );

  /// Verifies a one-time password and returns a token to complete the login.
  ///
  /// If [EmailAccountOtpVerificationResult.accountExists] is `true`, pass the
  /// token to [finishOtpLogin] to sign in. Otherwise, have the user accept the
  /// terms (and optionally set a password if
  /// [EmailAccountOtpVerificationResult.allowPassword] is `true`) and pass it
  /// to [finishOtpRegistration] to create the account.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts to verify the code.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists for
  ///   the given [otpLoginRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<_iaic.EmailAccountOtpVerificationResult> verifyOtpLoginCode({
    required _isc.UuidValue otpLoginRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<_iaic.EmailAccountOtpVerificationResult>(
    'emailIdp',
    'verifyOtpLoginCode',
    {
      'otpLoginRequestId': otpLoginRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a passwordless login for an existing account and returns a new
  /// session.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or no account exists for the email.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> finishOtpLogin({
    required String otpLoginToken,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishOtpLogin',
    {'otpLoginToken': otpLoginToken},
  );

  /// Completes a passwordless login for an email without an account, by
  /// creating a new auth user with a profile and attaching the verified email
  /// to it.
  ///
  /// Must only be called after the user accepted the terms. The [password] is
  /// optional, and may only be set if
  /// [EmailAccountOtpVerificationResult.allowPassword] was `true`.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the login request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if a password is
  ///   given but not allowed, or it does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [otpLoginToken] is
  ///   invalid or an account already exists for the email.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishOtpRegistration({
    required String otpLoginToken,
    String? password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishOtpRegistration',
    {
      'otpLoginToken': otpLoginToken,
      'password': password,
    },
  );

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// {@category Endpoint}
class EndpointMarketplaceExtra extends _isc.EndpointRef {
  EndpointMarketplaceExtra(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'marketplaceExtra';

  _ida.Future<List<_i0vcfhnc.WishlistItem>> wishlist() =>
      caller.callServerEndpoint<List<_i0vcfhnc.WishlistItem>>(
        'marketplaceExtra',
        'wishlist',
        {},
      );

  _ida.Future<_i0vcfhnc.WishlistItem> toggleWishlist({
    required int productId,
  }) => caller.callServerEndpoint<_i0vcfhnc.WishlistItem>(
    'marketplaceExtra',
    'toggleWishlist',
    {'productId': productId},
  );

  _ida.Future<List<_izbpoeda.BuyerRequirement>> listRequirements() =>
      caller.callServerEndpoint<List<_izbpoeda.BuyerRequirement>>(
        'marketplaceExtra',
        'listRequirements',
        {},
      );

  _ida.Future<_izbpoeda.BuyerRequirement> createRequirement({
    required String title,
    required String description,
    required String category,
    required int quantity,
    int? budgetPaise,
    String? city,
    String? state,
  }) => caller.callServerEndpoint<_izbpoeda.BuyerRequirement>(
    'marketplaceExtra',
    'createRequirement',
    {
      'title': title,
      'description': description,
      'category': category,
      'quantity': quantity,
      'budgetPaise': budgetPaise,
      'city': city,
      'state': state,
    },
  );

  _ida.Future<_itzn3mk3.RequirementResponse> respondRequirement({
    required int requirementId,
    required String message,
    int? quotedPaise,
  }) => caller.callServerEndpoint<_itzn3mk3.RequirementResponse>(
    'marketplaceExtra',
    'respondRequirement',
    {
      'requirementId': requirementId,
      'message': message,
      'quotedPaise': quotedPaise,
    },
  );

  _ida.Future<List<_iyi705kw.AppNotification>> notifications() =>
      caller.callServerEndpoint<List<_iyi705kw.AppNotification>>(
        'marketplaceExtra',
        'notifications',
        {},
      );

  _ida.Future<_iyi705kw.AppNotification> markNotificationRead({
    required int notificationId,
  }) => caller.callServerEndpoint<_iyi705kw.AppNotification>(
    'marketplaceExtra',
    'markNotificationRead',
    {'notificationId': notificationId},
  );

  _ida.Future<Map<String, int>> sellerStats() =>
      caller.callServerEndpoint<Map<String, int>>(
        'marketplaceExtra',
        'sellerStats',
        {},
      );
}

/// {@category Endpoint}
class EndpointProduct extends _isc.EndpointRef {
  EndpointProduct(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  _ida.Future<_idm7l56a.Product> createDraft({
    required String name,
    required String description,
    _idt.ByteData? photo,
    int? pricePaise,
    String? category,
    String? unit,
    String? city,
    String? state,
    String? craft,
  }) => caller.callServerEndpoint<_idm7l56a.Product>(
    'product',
    'createDraft',
    {
      'name': name,
      'description': description,
      'photo': photo,
      'pricePaise': pricePaise,
      'category': category,
      'unit': unit,
      'city': city,
      'state': state,
      'craft': craft,
    },
  );

  _ida.Future<_idt.ByteData?> getPhoto({required int productId}) =>
      caller.callServerEndpoint<_idt.ByteData?>(
        'product',
        'getPhoto',
        {'productId': productId},
      );

  _ida.Future<List<_idm7l56a.Product>> listMyDrafts() =>
      caller.callServerEndpoint<List<_idm7l56a.Product>>(
        'product',
        'listMyDrafts',
        {},
      );

  _ida.Future<List<_idm7l56a.Product>> listMyProducts() =>
      caller.callServerEndpoint<List<_idm7l56a.Product>>(
        'product',
        'listMyProducts',
        {},
      );

  _ida.Future<List<_idm7l56a.Product>> catalog({required String query}) =>
      caller.callServerEndpoint<List<_idm7l56a.Product>>(
        'product',
        'catalog',
        {'query': query},
      );

  _ida.Future<_idm7l56a.Product> publish({required int productId}) =>
      caller.callServerEndpoint<_idm7l56a.Product>(
        'product',
        'publish',
        {'productId': productId},
      );

  _ida.Future<_idm7l56a.Product> hide({required int productId}) =>
      caller.callServerEndpoint<_idm7l56a.Product>(
        'product',
        'hide',
        {'productId': productId},
      );

  _ida.Future<_idm7l56a.Product> updateDraft({
    required int productId,
    required String name,
    required String description,
    int? pricePaise,
    String? category,
    String? unit,
  }) => caller.callServerEndpoint<_idm7l56a.Product>(
    'product',
    'updateDraft',
    {
      'productId': productId,
      'name': name,
      'description': description,
      'pricePaise': pricePaise,
      'category': category,
      'unit': unit,
    },
  );

  _ida.Future<bool> deleteDraft({required int productId}) =>
      caller.callServerEndpoint<bool>(
        'product',
        'deleteDraft',
        {'productId': productId},
      );
}

/// {@category Endpoint}
class EndpointProfile extends _isc.EndpointRef {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  _ida.Future<_i8viowtb.AccountProfile?> getMine() =>
      caller.callServerEndpoint<_i8viowtb.AccountProfile?>(
        'profile',
        'getMine',
        {},
      );

  _ida.Future<_i8viowtb.AccountProfile> completeOnboarding({
    required String displayName,
    required _ibpr19yd.MarketplaceRole role,
    String? businessName,
    String? craftCategory,
    String? city,
    String? state,
    String? address,
  }) => caller.callServerEndpoint<_i8viowtb.AccountProfile>(
    'profile',
    'completeOnboarding',
    {
      'displayName': displayName,
      'role': role,
      'businessName': businessName,
      'craftCategory': craftCategory,
      'city': city,
      'state': state,
      'address': address,
    },
  );

  _ida.Future<bool> verifyProducerPan({required String panNumber}) =>
      caller.callServerEndpoint<bool>(
        'profile',
        'verifyProducerPan',
        {'panNumber': panNumber},
      );
}

/// {@category Endpoint}
class EndpointTrade extends _isc.EndpointRef {
  EndpointTrade(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'trade';

  _ida.Future<List<_ir66x6wy.TradeRequest>> listMine() =>
      caller.callServerEndpoint<List<_ir66x6wy.TradeRequest>>(
        'trade',
        'listMine',
        {},
      );

  _ida.Future<_ir66x6wy.TradeRequest> requestQuote({
    required int productId,
    required int quantity,
    required String requirements,
  }) => caller.callServerEndpoint<_ir66x6wy.TradeRequest>(
    'trade',
    'requestQuote',
    {
      'productId': productId,
      'quantity': quantity,
      'requirements': requirements,
    },
  );

  _ida.Future<_ir66x6wy.TradeRequest> quote({
    required int requestId,
    required int totalPaise,
  }) => caller.callServerEndpoint<_ir66x6wy.TradeRequest>(
    'trade',
    'quote',
    {
      'requestId': requestId,
      'totalPaise': totalPaise,
    },
  );

  _ida.Future<_ir66x6wy.TradeRequest> accept({required int requestId}) =>
      caller.callServerEndpoint<_ir66x6wy.TradeRequest>(
        'trade',
        'accept',
        {'requestId': requestId},
      );
}

/// {@category Endpoint}
class EndpointUtility extends _isc.EndpointRef {
  EndpointUtility(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'utility';

  /// Fast suggested price in paise based on artisan product categories and keywords
  _ida.Future<int> suggestedPrice({
    required String name,
    required String category,
  }) => caller.callServerEndpoint<int>(
    'utility',
    'suggestedPrice',
    {
      'name': name,
      'category': category,
    },
  );

  /// Full pricing engine calculation porting pricing_engine.py
  _ida.Future<Map<String, String>> calculatePrice({
    required String productId,
    required String category,
    required String description,
    required bool isBulk,
  }) => caller.callServerEndpoint<Map<String, String>>(
    'utility',
    'calculatePrice',
    {
      'productId': productId,
      'category': category,
      'description': description,
      'isBulk': isBulk,
    },
  );

  /// AI Catalog generation with Gemini API or deterministic artisan template fallback
  _ida.Future<String> generateCatalogDescription({
    required String name,
    required String category,
    String? voiceText,
  }) => caller.callServerEndpoint<String>(
    'utility',
    'generateCatalogDescription',
    {
      'name': name,
      'category': category,
      'voiceText': voiceText,
    },
  );

  /// Port of improve-product-photo: returns photo safely (graceful fallback)
  _ida.Future<_idt.ByteData?> improvePhoto({required _idt.ByteData? photo}) =>
      caller.callServerEndpoint<_idt.ByteData?>(
        'utility',
        'improvePhoto',
        {'photo': photo},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _isc.EndpointRef {
  EndpointGreeting(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _ida.Future<_i6ek115x.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i6ek115x.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    marketplaceExtra = EndpointMarketplaceExtra(this);
    product = EndpointProduct(this);
    profile = EndpointProfile(this);
    trade = EndpointTrade(this);
    utility = EndpointUtility(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointMarketplaceExtra marketplaceExtra;

  late final EndpointProduct product;

  late final EndpointProfile profile;

  late final EndpointTrade trade;

  late final EndpointUtility utility;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'marketplaceExtra': marketplaceExtra,
    'product': product,
    'profile': profile,
    'trade': trade,
    'utility': utility,
    'greeting': greeting,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
