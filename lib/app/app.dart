import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth/auth_prompt_controller.dart';
import '../core/l10n/l10n.dart';
import '../core/l10n/locale_controller.dart';
import '../core/offline/sync_trigger.dart';
import '../core/theme/app_theme.dart';
import '../features/ai_chat/presentation/ai_chat_bubble.dart';
import '../features/auth/presentation/auth_prompt_sheet.dart';
import '../features/profile/presentation/meta_providers.dart';
import '../features/profile/presentation/update_required_screen.dart';
import 'router.dart';

class UpazilaApp extends ConsumerWidget {
  const UpazilaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Kicks off the offline-content sync once for the app's lifetime
    // (Section: offline-first plan) - not used for its value, just its
    // side effect of starting SyncEngine.syncAll().
    ref.watch(offlineSyncStarterProvider);
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeControllerProvider);

    // Sign-in / verify-phone popup: any screen can trigger this via
    // `ref.ensureAuthed(...)` (see core/auth/auth_gate.dart). Shown as a
    // bottom sheet on the router's own Navigator (rootNavigatorKey) - not a
    // pushed route - so whatever the user was doing stays underneath and
    // resumes automatically on success.
    ref.listen<AuthPromptRequest?>(authPromptControllerProvider, (previous, next) {
      if (next == null) return;
      final navigatorContext = rootNavigatorKey.currentContext;
      if (navigatorContext == null) return;
      showModalBottomSheet<void>(
        context: navigatorContext,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => AuthPromptSheet(mode: next.mode),
      ).then((_) {
        // Closed by swipe/back rather than success - clear the pending
        // request so a stale resume callback can never fire later.
        if (ref.read(authPromptControllerProvider) != null) {
          ref.read(authPromptControllerProvider.notifier).dismiss();
        }
      });
    });

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      // Section 17 Phase 4 AI layer follow-up: the floating chat bubble is
      // mounted once here (above every route, shell tabs and pushed screens
      // alike) rather than per-screen, same reasoning as `_VersionGate`.
      builder: (context, child) => Stack(
        children: [
          _VersionGate(child: child ?? const SizedBox.shrink()),
          const Positioned.fill(child: AiChatBubble()),
        ],
      ),
    );
  }
}

/// Section 8.7: block the whole UI when the backend says this build is too
/// old. Rendered inside `MaterialApp.builder` so theme + localizations exist.
class _VersionGate extends ConsumerWidget {
  const _VersionGate({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocked = ref.watch(updateRequiredProvider).valueOrNull ?? false;
    if (!blocked) return child;
    final latest = ref.watch(appMetaProvider).valueOrNull?.latestAppVersion;
    return UpdateRequiredScreen(latestVersion: latest);
  }
}
