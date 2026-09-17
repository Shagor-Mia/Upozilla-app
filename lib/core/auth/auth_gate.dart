import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';
import 'auth_prompt_controller.dart';

/// The mobile equivalent of the web's `requireAuth`/`handleAuthError`: call
/// this from a button's `onPressed` (or right before submitting a form)
/// instead of pushing `/auth/login` or showing a "please sign in" dialog.
///
/// Screens stay fully browsable while signed out - nothing is pre-locked
/// except where phone-verification is genuinely required - and the popup
/// only appears the moment the visitor actually tries the gated action. Once
/// they sign in (and verify their phone, if that was also required), [action]
/// runs automatically - the exact thing they were trying to do resumes in
/// place instead of being lost.
extension AuthGate on WidgetRef {
  /// Runs [action] immediately if already allowed; otherwise opens the
  /// sign-in (then, if needed, verify-phone) sheet and re-runs this same
  /// check once that's resolved. Returns `true` if [action] ran synchronously.
  ///
  /// Note: chaining sign-in -> verify-phone this way relies on the two
  /// prompts never being open at once, which holds today only because the
  /// backend marks the phone verified as part of the OTP flow itself (both
  /// `login` and `register` purposes - see `auth/service.py`), and the sheet's
  /// resume chain is OTP-only (its "sign in with password" link exits to a
  /// full screen instead, outside this chain). So a signed-in-via-OTP user is
  /// always already phone-verified by the time this re-checks, and the
  /// verify-phone branch below never actually fires as a *chained* step in
  /// practice. If a non-OTP method ever joins this resume chain, re-check
  /// that `AuthPromptController`/the bottom-sheet host in `app.dart` can't
  /// end up opening a second sheet before the first has finished closing.
  bool ensureAuthed({required void Function() action, bool requirePhoneVerified = false}) {
    final auth = read(authControllerProvider).valueOrNull;
    final isSignedIn = auth?.isAuthenticated ?? false;

    if (!isSignedIn) {
      read(authPromptControllerProvider.notifier).requireSignIn(
        onSuccess: () => ensureAuthed(action: action, requirePhoneVerified: requirePhoneVerified),
      );
      return false;
    }

    if (requirePhoneVerified && !auth!.isPhoneVerified) {
      read(authPromptControllerProvider.notifier).requireVerifiedPhone(
        onSuccess: () => ensureAuthed(action: action, requirePhoneVerified: requirePhoneVerified),
      );
      return false;
    }

    action();
    return true;
  }
}
