import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_exception.dart';
import '../l10n/l10n.dart';
import 'error_state.dart';

/// One place that decides how loading / error / data render for server state
/// (Section 20.4's "one fetching pattern reused everywhere", applied to Flutter).
class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.loading,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: true,
      skipLoadingOnReload: true,
      data: data,
      loading: () => loading ?? const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorState(
        message: describeError(context, error),
        isOffline: error is OfflineException,
        onRetry: onRetry,
      ),
    );
  }
}

/// User-facing message for any error; [AppException] messages are already
/// safe to show, anything else collapses to a generic string.
String describeError(BuildContext context, Object error) {
  final l10n = context.l10n;
  return switch (error) {
    OfflineException() => l10n.offlineBanner,
    CancelledException() => l10n.errorTitle,
    AppException(:final message) => message,
    _ => l10n.errorTitle,
  };
}
