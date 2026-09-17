import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/auth/otp_args.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/snackbars.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key, required this.args});

  final OtpArgs args;

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  static const _codeLength = 6;

  final _codeController = TextEditingController();
  late OtpArgs _args = widget.args;
  bool _submitting = false;
  String? _codeError;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length != _codeLength) {
      setState(() => _codeError = context.l10n.otpMustBe6Digits);
      return;
    }
    setState(() {
      _submitting = true;
      _codeError = null;
    });
    try {
      await ref.read(authControllerProvider.notifier).verifyOtp(
            phone: _args.phone,
            code: code,
            purpose: _args.purpose,
            fullName: _args.fullName,
          );
      if (mounted) context.go(AppRoutes.profile);
    } on ValidationException catch (e) {
      if (mounted) setState(() => _codeError = e.fieldError('code') ?? e.message);
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _resend() async {
    setState(() => _submitting = true);
    try {
      final result = await ref
          .read(authControllerProvider.notifier)
          .requestOtp(phone: _args.phone, purpose: _args.purpose);
      if (!mounted) return;
      setState(() => _args = _args.copyWith(devCode: result.devCode, expiresInSeconds: result.expiresInSeconds));
      showMessageSnackBar(context, context.l10n.otpSentTo(maskPhone(_args.phone)));
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final devCode = _args.devCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.verifyOtp)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.otpSentTo(maskPhone(_args.phone)), style: Theme.of(context).textTheme.bodyLarge),
              if (devCode != null) ...[
                const SizedBox(height: 8),
                // Local-dev convenience only: the backend never returns this in production.
                Text(l10n.otpDevCode(devCode), style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
              ],
              const SizedBox(height: 24),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: _codeLength,
                autofocus: true,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: l10n.otpCode, errorText: _codeError, counterText: ''),
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
                textAlign: TextAlign.center,
                onSubmitted: (_) => _verify(),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _submitting ? null : _verify,
                child: _submitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.verifyOtp),
              ),
              TextButton(onPressed: _submitting ? null : _resend, child: Text(l10n.resendOtp)),
            ],
          ),
        ),
      ),
    );
  }
}
