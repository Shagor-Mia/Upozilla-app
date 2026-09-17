import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/auth/auth_prompt_controller.dart';
import '../../../core/auth/otp.dart';
import '../../../core/auth/otp_args.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/snackbars.dart';

enum _Step { phone, otp }

/// The in-place sign-in / verify-phone popup: a bottom sheet (not a pushed
/// route) so whatever screen/action triggered it stays underneath, and
/// succeeding resumes that action automatically via `AuthPromptController`.
///
/// Phone + OTP only (the default and primary method, same as web) - a link
/// falls back to the full-screen password/email flow for the less common
/// case, closing this sheet since that flow isn't resume-aware.
class AuthPromptSheet extends ConsumerStatefulWidget {
  const AuthPromptSheet({super.key, required this.mode});

  final AuthPromptMode mode;

  @override
  ConsumerState<AuthPromptSheet> createState() => _AuthPromptSheetState();
}

class _AuthPromptSheetState extends ConsumerState<AuthPromptSheet> {
  static const _codeLength = 6;

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();

  _Step _step = _Step.phone;
  bool _isRegister = false;
  bool _submitting = false;
  String? _serverPhoneError;
  String? _codeError;
  OtpArgs? _args;

  bool get _isVerifyPhone => widget.mode == AuthPromptMode.verifyPhone;

  @override
  void initState() {
    super.initState();
    if (_isVerifyPhone) {
      final phone = ref.read(authControllerProvider).valueOrNull?.user?.phone;
      if (phone != null) {
        // The account already has a phone on file - skip straight to
        // requesting a code for it instead of asking again.
        WidgetsBinding.instance.addPostFrameCallback((_) => _requestCode(phone));
      }
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  OtpPurpose get _purpose =>
      _isVerifyPhone ? OtpPurpose.verifyPhone : (_isRegister ? OtpPurpose.register : OtpPurpose.login);

  Future<void> _requestCode(String phone) async {
    setState(() {
      _submitting = true;
      _serverPhoneError = null;
    });
    try {
      final result = await ref.read(authControllerProvider.notifier).requestOtp(phone: phone, purpose: _purpose);
      if (!mounted) return;
      setState(() {
        _args = OtpArgs(
          phone: phone,
          purpose: _purpose,
          fullName: _isRegister ? _nameController.text.trim() : null,
          devCode: result.devCode,
          expiresInSeconds: result.expiresInSeconds,
        );
        _step = _Step.otp;
      });
    } on ValidationException catch (e) {
      if (!mounted) return;
      setState(() => _serverPhoneError = e.fieldError('phone') ?? e.message);
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _submitPhone() async {
    setState(() => _serverPhoneError = null);
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = normalizeBdPhone(_phoneController.text);
    if (phone == null) return;
    await _requestCode(phone);
  }

  Future<void> _resend() async {
    final args = _args;
    if (args == null) return;
    setState(() => _submitting = true);
    try {
      final result = await ref.read(authControllerProvider.notifier).requestOtp(phone: args.phone, purpose: args.purpose);
      if (!mounted) return;
      setState(() => _args = args.copyWith(devCode: result.devCode, expiresInSeconds: result.expiresInSeconds));
      showMessageSnackBar(context, context.l10n.otpSentTo(maskPhone(args.phone)));
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _verify() async {
    final args = _args;
    if (args == null) return;
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
            phone: args.phone,
            code: code,
            purpose: args.purpose,
            fullName: args.fullName,
          );
      if (!mounted) return;
      // Fires whatever action was waiting on this (e.g. re-submit the sell
      // form, re-send the message) before closing the sheet.
      ref.read(authPromptControllerProvider.notifier).succeed();
      Navigator.of(context).pop();
    } on ValidationException catch (e) {
      if (mounted) setState(() => _codeError = e.fieldError('code') ?? e.message);
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _useFullScreenPasswordLogin() {
    ref.read(authPromptControllerProvider.notifier).dismiss();
    Navigator.of(context).pop();
    context.push(AppRoutes.passwordLogin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              _isVerifyPhone ? l10n.verifyPhoneTileTitle : (_isRegister ? l10n.createAccount : l10n.signIn),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (_step == _Step.phone) _buildPhoneStep(l10n) else _buildOtpStep(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneStep(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_isVerifyPhone && _isRegister) ...[
            TextFormField(
              controller: _nameController,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l10n.fullName),
              validator: (value) => (value == null || value.trim().isEmpty) ? l10n.fullNameRequired : null,
            ),
            const SizedBox(height: 16),
          ],
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            autofocus: true,
            autofillHints: const [AutofillHints.telephoneNumber],
            decoration: InputDecoration(labelText: l10n.phoneNumber, hintText: l10n.phoneHint, prefixText: '+88 '),
            validator: (value) {
              if (_serverPhoneError != null) return _serverPhoneError;
              return normalizeBdPhone(value ?? '') == null ? l10n.invalidPhone : null;
            },
            onFieldSubmitted: (_) => _submitPhone(),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: _submitting ? null : _submitPhone,
            child: _submitting
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.sendOtp),
          ),
          if (!_isVerifyPhone) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _submitting ? null : () => setState(() => _isRegister = !_isRegister),
              child: Text(_isRegister ? l10n.alreadyHaveAccount : l10n.noAccountYet),
            ),
            TextButton(
              onPressed: _submitting ? null : _useFullScreenPasswordLogin,
              child: Text(l10n.loginWithPassword),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOtpStep(AppLocalizations l10n) {
    final args = _args!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.otpSentTo(maskPhone(args.phone)), style: Theme.of(context).textTheme.bodyMedium),
        if (args.devCode != null) ...[
          const SizedBox(height: 8),
          Text(l10n.otpDevCode(args.devCode!), style: TextStyle(color: Theme.of(context).colorScheme.tertiary)),
        ],
        const SizedBox(height: 20),
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
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _submitting ? null : _verify,
          child: _submitting
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l10n.verifyOtp),
        ),
        TextButton(onPressed: _submitting ? null : _resend, child: Text(l10n.resendOtp)),
      ],
    );
  }
}
