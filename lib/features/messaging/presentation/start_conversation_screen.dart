import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../data/messaging_repository.dart';
import '../domain/conversation.dart';

/// Route-only bridge for "Message seller" on a listing detail screen. Other
/// features navigate here instead of importing `MessagingRepository` directly
/// (Section 20.8: a feature never imports another feature's internals) - this
/// screen calls `startConversation` and hands off to the real chat screen.
final _startConversationProvider = FutureProvider.autoDispose.family<Conversation, ({String listingType, String listingId})>(
  (ref, args) {
    return ref.watch(messagingRepositoryProvider).startConversation(
          listingType: args.listingType,
          listingId: args.listingId,
        );
  },
);

class StartConversationScreen extends ConsumerWidget {
  const StartConversationScreen({super.key, required this.listingType, required this.listingId});

  final String listingType;
  final String listingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args = (listingType: listingType, listingId: listingId);
    final value = ref.watch(_startConversationProvider(args));

    ref.listen(_startConversationProvider(args), (previous, next) {
      final conversation = next.valueOrNull;
      if (conversation != null) {
        context.pushReplacement(AppRoutes.conversation(conversation.id));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.messages)),
      body: AsyncValueWidget<Conversation>(
        value: value,
        onRetry: () => ref.invalidate(_startConversationProvider(args)),
        data: (_) => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
