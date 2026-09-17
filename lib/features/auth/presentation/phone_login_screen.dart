import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/auth/otp.dart';
import '../../../core/auth/otp_args.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/snackbars.dart';

/// Phone OTP entry point for both sign-in and registration (Phase 2 flow).
class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key, this.startInRegisterMode = false});

  final bool startInRegisterMode;

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  late bool _isRegister = widget.startInRegisterMode;
  bool _submitting = false;
  String? _serverPhoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    _serverPhoneError = null;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = normalizeBdPhone(_phoneController.text);
    if (phone == null) return;
    final purpose = _isRegister ? OtpPurpose.register : OtpPurpose.login;
    final fullName = _isRegister ? _nameController.text.trim() : null;

    setState(() => _submitting = true);
    try {
      final result = await ref.read(authControllerProvider.notifier).requestOtp(phone: phone, purpose: purpose);
      if (!mounted) return;
      await context.push(
        AppRoutes.otp,
        extra: OtpArgs(
          phone: phone,
          purpose: purpose,
          fullName: fullName,
          devCode: result.devCode,
          expiresInSeconds: result.expiresInSeconds,
        ),
      );
    } on ValidationException catch (e) {
      if (!mounted) return;
      setState(() => _serverPhoneError = e.fieldError('phone') ?? e.message);
      _formKey.currentState?.validate();
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(_isRegister ? l10n.createAccount : l10n.signIn)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_isRegister) ...[
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
                  autofillHints: const [AutofillHints.telephoneNumber],
                  decoration: InputDecoration(labelText: l10n.phoneNumber, hintText: l10n.phoneHint, prefixText: '+88 '),
                  validator: (value) {
                    if (_serverPhoneError != null) return _serverPhoneError;
                    return normalizeBdPhone(value ?? '') == null ? l10n.invalidPhone : null;
                  },
                  onFieldSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.sendOtp),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _submitting ? null : () => setState(() => _isRegister = !_isRegister),
                  child: Text(_isRegister ? l10n.alreadyHaveAccount : l10n.noAccountYet),
                ),
                if (!_isRegister)
                  TextButton(
                    onPressed: _submitting ? null : () => context.push(AppRoutes.passwordLogin),
                    child: Text(l10n.loginWithPassword),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
