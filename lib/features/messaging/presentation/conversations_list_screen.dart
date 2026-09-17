import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/online_only_gate.dart';
import '../domain/conversation.dart';
import 'messaging_providers.dart';

class ConversationsListScreen extends ConsumerWidget {
  const ConversationsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(conversationsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.messages)),
      // Messaging is WebSocket + REST, inherently online-only (Section:
      // offline-first plan).
      body: OnlineOnlyGate(child: AsyncValueWidget<List<Conversation>>(
        value: value,
        onRetry: () => ref.invalidate(conversationsProvider),
        data: (conversations) {
          if (conversations.isEmpty) {
            return RefreshIndicator(
              onRefresh: () => ref.refresh(conversationsProvider.future).then((_) {}, onError: (_) {}),
              child: ListView(
                children: [
                  const SizedBox(height: 120),
                  EmptyState(
                    icon: Icons.forum_outlined,
                    title: l10n.noConversationsTitle,
                    body: l10n.noConversationsBody,
                  ),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(conversationsProvider.future).then((_) {}, onError: (_) {}),
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) => _ConversationTile(conversation: conversations[index]),
            ),
          );
        },
      )),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({required this.conversation});

  final Conversation conversation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final last = conversation.lastMessage;
    return ListTile(
      leading: CircleAvatar(
        child: Text(conversation.otherParty.fullName.isEmpty ? '?' : conversation.otherParty.fullName[0].toUpperCase()),
      ),
      title: Text(conversation.otherParty.fullName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [
          if (conversation.listingTitle != null) conversation.listingTitle!,
          if (last != null) last.body,
        ].join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (conversation.createdAt != null)
            Text(Formatters.date(conversation.createdAt!, locale: locale), style: theme.textTheme.bodySmall),
          if (conversation.unreadCount > 0) ...[
            const SizedBox(height: 4),
            CircleAvatar(
              radius: 10,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                '${conversation.unreadCount}',
                style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
          ],
        ],
      ),
      onTap: () => context.push(AppRoutes.conversation(conversation.id)),
    );
  }
}
