import 'package:flutter/material.dart';

import '../ai_chat_controller.dart';

/// Renders one Q&A turn as two bubbles (question end-aligned, answer
/// start-aligned) - same visual convention as messaging's `_MessageBubble`
/// (`features/messaging/presentation/chat_screen.dart`), shared here between
/// the full `AiChatScreen` and the floating `AiChatBubble` panel so the two
/// don't duplicate styling.
class ChatMessageRow extends StatelessWidget {
  const ChatMessageRow({super.key, required this.turn, this.dense = false});

  final ChatTurn turn;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Bubble(text: turn.question, mine: true, dense: dense),
        const SizedBox(height: 4),
        _Bubble(text: turn.answer, mine: false, dense: dense),
      ],
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.text, required this.mine, required this.dense});

  final String text;
  final bool mine;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = mine ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest;
    final foreground = mine ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface;
    final textStyle = dense ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium;
    return Align(
      alignment: mine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * (dense ? 0.85 : 0.75)),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.symmetric(horizontal: dense ? 10 : 14, vertical: dense ? 6 : 10),
        decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(16)),
        child: Text(text, style: textStyle?.copyWith(color: foreground)),
      ),
    );
  }
}
