import 'otp.dart';

/// Navigation payload from the phone/verify-phone screens to the OTP screen.
/// Passed as go_router `extra` so the phone number never appears in a route
/// URL. Lives in `core/` (not the `auth` feature) because more than one
/// feature constructs it - the profile feature's verify-phone flow reuses the
/// same `OtpVerifyScreen` the auth feature's sign-in flow does.
class OtpArgs {
  const OtpArgs({
    required this.phone,
    required this.purpose,
    this.fullName,
    this.devCode,
    this.expiresInSeconds = 300,
  });

  final String phone;
  final OtpPurpose purpose;
  final String? fullName;
  final String? devCode;
  final int expiresInSeconds;

  OtpArgs copyWith({String? devCode, int? expiresInSeconds}) => OtpArgs(
        phone: phone,
        purpose: purpose,
        fullName: fullName,
        devCode: devCode ?? this.devCode,
        expiresInSeconds: expiresInSeconds ?? this.expiresInSeconds,
      );
}
