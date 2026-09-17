/// Mirrors the backend `OtpPurpose` enum values used by the mobile flows.
/// `verifyPhone` is for an already-signed-in user attaching/confirming a phone
/// number; the backend requires a bearer token for that purpose (Section 10).
enum OtpPurpose {
  login('login'),
  register('register'),
  verifyPhone('verify_phone');

  const OtpPurpose(this.apiValue);

  final String apiValue;
}

/// `POST /auth/otp/request` response. `devCode` is only ever populated by the
/// console SMS gateway in local development.
class OtpRequestResult {
  const OtpRequestResult({required this.sent, required this.expiresInSeconds, this.devCode});

  final bool sent;
  final int expiresInSeconds;
  final String? devCode;

  factory OtpRequestResult.fromJson(Map<String, dynamic> json) => OtpRequestResult(
        sent: json['sent'] as bool? ?? true,
        expiresInSeconds: json['expires_in_seconds'] as int? ?? 300,
        devCode: json['dev_code'] as String?,
      );
}
