import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthPromptMode { signIn, verifyPhone }

/// One pending "please sign in / verify your phone" request, plus what to do
/// once it's resolved.
class AuthPromptRequest {
  const AuthPromptRequest({required this.mode, this.onSuccess});

  final AuthPromptMode mode;

  /// Re-runs whatever action needed auth, in place - the mobile equivalent of
  /// web's `requireAuth`/`handleAuthError` resume pattern.
  final void Function()? onSuccess;
}

/// Holds the currently-open auth prompt, if any. A single bottom-sheet host
/// (mounted once in `app.dart`, next to the AI chat bubble - see
/// `auth_prompt_sheet.dart`) watches this and shows/hides itself accordingly.
///
/// This replaces "push a full-screen /auth/login route and lose whatever the
/// user was doing" with "pop a sheet in place, then resume the exact action
/// that triggered it" - see `auth_gate.dart` for the call-site helper.
class AuthPromptController extends Notifier<AuthPromptRequest?> {
  @override
  AuthPromptRequest? build() => null;

  void requireSignIn({void Function()? onSuccess}) {
    state = AuthPromptRequest(mode: AuthPromptMode.signIn, onSuccess: onSuccess);
  }

  void requireVerifiedPhone({void Function()? onSuccess}) {
    state = AuthPromptRequest(mode: AuthPromptMode.verifyPhone, onSuccess: onSuccess);
  }

  /// Called by the sheet when the user closes it without completing
  /// (swipe-to-dismiss, back button) - clears state so a stale `onSuccess`
  /// can never fire later.
  void dismiss() => state = null;

  /// Called by the sheet right after a successful login/verification: clears
  /// state and fires the resume callback.
  void succeed() {
    final onSuccess = state?.onSuccess;
    state = null;
    onSuccess?.call();
  }
}

final authPromptControllerProvider = NotifierProvider<AuthPromptController, AuthPromptRequest?>(
  AuthPromptController.new,
);
