import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../domain/message.dart';
import 'chat_controller.dart';
import 'messaging_providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _draftController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _draftController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final body = _draftController.text;
    if (body.trim().isEmpty) return;
    _draftController.clear();
    await ref.read(chatControllerProvider(widget.id).notifier).sendMessage(body);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final conversationValue = ref.watch(conversationDetailProvider(widget.id));
    final chatState = ref.watch(chatControllerProvider(widget.id));
    final currentUserId = ref.watch(authControllerProvider).valueOrNull?.user?.id;

    ref.listen(chatControllerProvider(widget.id), (previous, next) {
      if ((previous?.messages.length ?? 0) != next.messages.length) _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(
        title: conversationValue.when(
          data: (c) => Text(c.otherParty.fullName),
          loading: () => Text(l10n.messages),
          error: (_, __) => Text(l10n.messages),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              chatState.live ? l10n.chatLive : l10n.chatPolling,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.loading
                ? const Center(child: CircularProgressIndicator())
                : chatState.messages.isEmpty
                    ? Center(child: Text(l10n.noMessagesYet))
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
                        itemCount: chatState.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatState.messages[index];
                          return _MessageBubble(message: message, mine: message.senderId == currentUserId);
                        },
                      ),
          ),
          if (chatState.error != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(describeError(context, chatState.error!), style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _draftController,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 2000,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(hintText: l10n.writeAMessage, counterText: ''),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: chatState.sending ? null : _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.mine});

  final Message message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final background = mine ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest;
    final foreground = mine ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    return Align(
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message.body, style: TextStyle(color: foreground)),
            if (message.createdAt != null) ...[
              const SizedBox(height: 4),
              Text(
                Formatters.dateTime(message.createdAt!, locale: locale),
                style: theme.textTheme.bodySmall?.copyWith(color: foreground.withValues(alpha: 0.75)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
