import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/async_value_widget.dart' show describeError;
import '../../../core/widgets/online_only_gate.dart';
import 'ai_chat_controller.dart';
import 'widgets/chat_message_row.dart';

/// Full-page view of the Section 17 Phase 4 RAG chatbot. See
/// `ai_chat_bubble.dart` for the floating-widget counterpart - both read the
/// single global `aiChatControllerProvider`, so a conversation started in one
/// is still visible in the other.
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
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
    final question = _draftController.text;
    if (question.trim().isEmpty) return;
    _draftController.clear();
    await ref.read(aiChatControllerProvider.notifier).sendMessage(question);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(aiChatControllerProvider);

    ref.listen(aiChatControllerProvider, (previous, next) {
      if ((previous?.turns.length ?? 0) != next.turns.length) _scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiChatTitle)),
      body: OnlineOnlyGate(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(l10n.aiChatSubtitle,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            Expanded(
              child: state.turns.isEmpty && !state.pending
                  ? Center(
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(l10n.aiChatEmptyState,
                              textAlign: TextAlign.center)))
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: state.turns.length + (state.pending ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.turns.length) {
                          return Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 4),
                              child: Text(l10n.aiChatThinking,
                                  style: Theme.of(context).textTheme.bodySmall),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: ChatMessageRow(turn: state.turns[index]),
                        );
                      },
                    ),
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(describeError(context, state.error!),
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
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
                        maxLength: 1000,
                        textInputAction: TextInputAction.send,
                        decoration: InputDecoration(
                            hintText: l10n.aiChatPlaceholder, counterText: ''),
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: state.pending ? null : _send),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(l10n.aiChatDisclaimer,
                  style: Theme.of(context).textTheme.bodySmall),
            ),
          ],
        ),
      ),
    );
  }
}
