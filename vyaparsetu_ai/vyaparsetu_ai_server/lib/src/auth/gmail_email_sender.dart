import 'dart:io';
import 'dart:math';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:serverpod/serverpod.dart' hide Message;

String sixDigitCode() {
  final random = Random.secure();
  return (100000 + random.nextInt(900000)).toString();
}

Future<void> sendVyaparSetuEmailCode(
  Session session, {
  required String email,
  UuidValue? accountRequestId,
  UuidValue? passwordResetRequestId,
  required String verificationCode,
  Transaction? transaction,
}) async {
  final smtpUser =
      Platform.environment['SMTP_USER'] ??
      Serverpod.instance.getPassword('smtpUser') ??
      '';
  final smtpPass =
      (Platform.environment['SMTP_PASS'] ??
              Serverpod.instance.getPassword('smtpPass') ??
              '')
          .replaceAll(' ', '');

  if (smtpUser.trim().isEmpty || smtpPass.isEmpty) {
    session.alert(
      'VyaparSetu verification code for $email: <$verificationCode>',
    );
    return;
  }

  try {
    final message = Message()
      ..from = Address(smtpUser.trim(), 'VyaparSetu')
      ..recipients = [email.trim()]
      ..subject = 'VyaparSetu verification code'
      ..html =
          '<h2>VyaparSetu verification code</h2>'
          '<p>Use this 6-digit code to continue:</p>'
          '<div style="font-size:28px;font-weight:bold;letter-spacing:6px">'
          '$verificationCode</div>'
          '<p>This code expires soon. Never share it with anyone.</p>';

    await send(message, gmail(smtpUser.trim(), smtpPass));
  } catch (error) {
    session.alert(
      'VyaparSetu verification code for $email: <$verificationCode>',
    );
    session.log(
      'Gmail SMTP delivery failed; verification code logged for development.',
      level: LogLevel.warning,
      exception: error,
    );
  }
}
