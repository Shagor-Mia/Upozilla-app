import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/empty_state.dart';

/// Placeholder: push notifications (FCM) are deliberately not wired yet —
/// there is no Firebase project. This screen exists so the navigation entry
/// point and deep-link path are stable when they arrive.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: EmptyState(
        icon: Icons.notifications_off_outlined,
        title: l10n.notificationsPlaceholderTitle,
        body: l10n.notificationsPlaceholderBody,
      ),
    );
  }
}
