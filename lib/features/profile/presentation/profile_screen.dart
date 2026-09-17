import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/auth/auth_state.dart';
import '../../../core/auth/otp.dart';
import '../../../core/auth/otp_args.dart';
import '../../../core/config/app_config.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/snackbars.dart';
import '../../unions/presentation/unions_providers.dart';
import 'meta_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).signOut();
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  /// Sign-in-gated navigation entries (messages/my listings/favorites): the
  /// tile always shows, but tapping while signed out goes to sign-in first
  /// rather than landing on a screen that will just 401.
  void _pushOrSignIn(BuildContext context, WidgetRef ref, String route) {
    final signedIn = ref.read(authControllerProvider).valueOrNull?.isAuthenticated ?? false;
    context.push(signedIn ? route : AppRoutes.login);
  }

  /// Language names are shown in their own script (not run through `l10n`)
  /// so a user can always find their language regardless of the app's
  /// current locale.
  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    final current = ref.read(localeControllerProvider);
    const options = [
      (locale: Locale('bn'), label: 'বাংলা'),
      (locale: Locale('en'), label: 'English'),
      (locale: Locale('ar'), label: 'العربية'),
    ];
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options)
              ListTile(
                title: Text(option.label),
                trailing: option.locale.languageCode == current.languageCode ? const Icon(Icons.check) : null,
                onTap: () {
                  ref.read(localeControllerProvider.notifier).setLocale(option.locale);
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final auth = ref.watch(authControllerProvider);
    final packageInfo = ref.watch(packageInfoProvider).valueOrNull;
    final config = ref.watch(appConfigProvider);
    final versionLabel = packageInfo == null ? '' : '${packageInfo.version}+${packageInfo.buildNumber}';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navProfile)),
      body: ListView(
        children: [
          auth.when(
            loading: () => const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator())),
            error: (_, __) => _SignedOutCard(onSignIn: () => context.push(AppRoutes.login)),
            data: (state) => state.isAuthenticated
                ? _SignedInCard(state: state, onSignOut: () => _signOut(context, ref))
                : _SignedOutCard(onSignIn: () => context.push(AppRoutes.login)),
          ),
          if ((auth.valueOrNull?.isAuthenticated ?? false) && !(auth.valueOrNull?.isPhoneVerified ?? true))
            _VerifyPhoneTile(phone: auth.valueOrNull?.user?.phone),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(l10n.sellSomething),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.sell),
          ),
          ListTile(
            leading: const Icon(Icons.forum_outlined),
            title: Text(l10n.messages),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pushOrSignIn(context, ref, AppRoutes.conversations),
          ),
          ListTile(
            leading: const Icon(Icons.list_alt_outlined),
            title: Text(l10n.myListings),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pushOrSignIn(context, ref, AppRoutes.myListings),
          ),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(l10n.myShopsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pushOrSignIn(context, ref, AppRoutes.myShops),
          ),
          ListTile(
            leading: const Icon(Icons.handshake_outlined),
            title: Text(l10n.myContractsTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pushOrSignIn(context, ref, AppRoutes.contracts),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: Text(l10n.favoritesTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _pushOrSignIn(context, ref, AppRoutes.favorites),
          ),
          if ((ref.watch(myRepresentativeProvider).valueOrNull) case final rep?)
            ListTile(
              leading: const Icon(Icons.groups_outlined),
              title: Text(l10n.myRepresentativeProfile),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.representativeEdit(rep.id), extra: rep),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(l10n.notifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.notifications),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance_outlined),
            title: Text(l10n.servicesTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.servicesList),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.translate_outlined),
            title: Text(l10n.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context, ref),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.appVersion(versionLabel)),
            subtitle: Text('${config.flavor.name} · ${config.apiBaseUrl}'),
          ),
        ],
      ),
    );
  }
}

class _SignedInCard extends StatelessWidget {
  const _SignedInCard({required this.state, required this.onSignOut});

  final AuthState state;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final user = state.user;
    final phone = user?.phone;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                child: Text(
                  (user?.fullName.isNotEmpty ?? false) ? user!.fullName[0].toUpperCase() : '?',
                  style: theme.textTheme.titleLarge,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user == null ? l10n.signIn : l10n.signedInAs(user.fullName), style: theme.textTheme.titleMedium),
                    if (phone != null) Text(maskPhone(phone), style: theme.textTheme.bodySmall),
                    if (user?.email != null) Text(user!.email!, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          state.isPhoneVerified ? Icons.verified_user_rounded : Icons.shield_outlined,
                          size: 16,
                          color: state.isPhoneVerified ? theme.colorScheme.primary : theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          state.isPhoneVerified ? l10n.phoneVerified : l10n.phoneNotVerified,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(onPressed: onSignOut, icon: const Icon(Icons.logout), label: Text(l10n.signOut)),
        ],
      ),
    );
  }
}

class _SignedOutCard extends StatelessWidget {
  const _SignedOutCard({required this.onSignIn});

  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.notSignedIn, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l10n.signInPrompt, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: onSignIn, icon: const Icon(Icons.login), label: Text(l10n.signIn)),
        ],
      ),
    );
  }
}

/// Shown when signed in but `!state.isPhoneVerified`. When [phone] is set,
/// tapping immediately requests an OTP for it and opens the (purpose-agnostic)
/// OTP screen. The backend also supports *attaching* a fresh phone number to
/// an email/password account via the same `verify_phone` OTP purpose
/// (`attach_verified_phone` in `modules/auth/service.py`), so when [phone] is
/// null this prompts for a number first rather than dead-ending the user.
class _VerifyPhoneTile extends ConsumerStatefulWidget {
  const _VerifyPhoneTile({required this.phone});

  final String? phone;

  @override
  ConsumerState<_VerifyPhoneTile> createState() => _VerifyPhoneTileState();
}

class _VerifyPhoneTileState extends ConsumerState<_VerifyPhoneTile> {
  bool _submitting = false;

  Future<void> _startVerification(String phone) async {
    setState(() => _submitting = true);
    try {
      final result =
          await ref.read(authControllerProvider.notifier).requestOtp(phone: phone, purpose: OtpPurpose.verifyPhone);
      if (!mounted) return;
      await context.push(
        AppRoutes.otp,
        extra: OtpArgs(
          phone: phone,
          purpose: OtpPurpose.verifyPhone,
          devCode: result.devCode,
          expiresInSeconds: result.expiresInSeconds,
        ),
      );
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _promptForPhoneThenVerify() async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    final phone = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.addPhoneNumberTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(labelText: l10n.phoneNumber, hintText: l10n.phoneHint, prefixText: '+88 '),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(normalizeBdPhone(controller.text)),
            child: Text(l10n.sendOtp),
          ),
        ],
      ),
    );
    controller.dispose();
    if (phone == null) {
      if (mounted) showMessageSnackBar(context, l10n.invalidPhone);
      return;
    }
    await _startVerification(phone);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final phone = widget.phone;
    return ListTile(
      leading: const Icon(Icons.shield_outlined),
      title: Text(l10n.verifyPhoneTileTitle),
      subtitle: Text(phone == null ? l10n.addPhoneNumberBody : l10n.verifyPhoneTileBody),
      trailing: _submitting
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
          : const Icon(Icons.chevron_right),
      onTap: _submitting ? null : () => phone == null ? _promptForPhoneThenVerify() : _startVerification(phone),
    );
  }
}
