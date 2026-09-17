import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart' show describeError;
import '../../../core/widgets/online_only_gate.dart';
import 'ai_chat_controller.dart';
import 'widgets/chat_message_row.dart';

/// Floating chat widget (Section 17 Phase 4, "AI settings upgrade" follow-up)
/// - mounted once in `app/app.dart`'s `MaterialApp.router(builder:)`, so it
/// sits above every route (shell tabs and pushed screens alike), matching a
/// reference storefront's always-visible bottom-right bubble. Reads the same
/// single global `aiChatControllerProvider` as `AiChatScreen`.
///
/// Offset far enough up (`_bottomOffset`) to clear the 5-tab bottom
/// `NavigationBar` (`app/shell_scaffold.dart`) on shell screens; on pushed
/// screens without that bar this leaves a slightly larger-than-necessary gap,
/// accepted for a single consistent position everywhere.
class AiChatBubble extends ConsumerStatefulWidget {
  const AiChatBubble({super.key});

  static const _bottomOffset = 88.0;

  @override
  ConsumerState<AiChatBubble> createState() => _AiChatBubbleState();
}

class _AiChatBubbleState extends ConsumerState<AiChatBubble> {
  bool _open = false;
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
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
    final theme = Theme.of(context);
    final state = ref.watch(aiChatControllerProvider);
    final mediaQuery = MediaQuery.of(context);
    // This widget has no Scaffold of its own (mounted above the app's
    // Navigator in `app/app.dart`), so it doesn't get automatic
    // resizeToAvoidBottomInset keyboard handling - shift the panel up by the
    // keyboard's height manually, and shrink it so it never runs off the
    // top of the screen while the keyboard is open.
    final keyboardHeight = mediaQuery.viewInsets.bottom;
    final panelHeight = (mediaQuery.size.height * 0.6)
        .clamp(0.0, mediaQuery.size.height - keyboardHeight - 96);

    ref.listen(aiChatControllerProvider, (previous, next) {
      if (_open && (previous?.turns.length ?? 0) != next.turns.length) {
        _scrollToBottom();
      }
    });

    return Stack(
      children: [
        if (_open)
          PositionedDirectional(
            bottom: AiChatBubble._bottomOffset + 64 + keyboardHeight,
            end: 16,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: mediaQuery.size.width * 0.9 > 360
                    ? 360
                    : mediaQuery.size.width * 0.9,
                height: panelHeight,
                color: theme.colorScheme.surface,
                child: Column(
                  children: [
                    Container(
                      color: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome,
                              color: theme.colorScheme.onPrimary, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.aiChatTitle,
                              style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.onPrimary),
                            ),
                          ),
                          Semantics(
                            button: true,
                            label: l10n.aiChatExpand,
                            child: IconButton(
                              icon: Icon(Icons.open_in_full,
                                  color: theme.colorScheme.onPrimary, size: 18),
                              onPressed: () {
                                setState(() => _open = false);
                                context.push(AppRoutes.askAi);
                              },
                            ),
                          ),
                          Semantics(
                            button: true,
                            label: l10n.aiChatCloseWidget,
                            child: IconButton(
                              icon: Icon(Icons.close,
                                  color: theme.colorScheme.onPrimary),
                              onPressed: () => setState(() => _open = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: OnlineOnlyGate(
                        child: Column(
                          children: [
                            Expanded(
                              child: state.turns.isEmpty && !state.pending
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Text(
                                          l10n.aiChatEmptyState,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      controller: _scrollController,
                                      padding: const EdgeInsets.all(8),
                                      itemCount: state.turns.length +
                                          (state.pending ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (index >= state.turns.length) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 6, horizontal: 4),
                                            child: Text(l10n.aiChatThinking,
                                                style:
                                                    theme.textTheme.bodySmall),
                                          );
                                        }
                                        return ChatMessageRow(
                                            turn: state.turns[index],
                                            dense: true);
                                      },
                                    ),
                            ),
                            if (state.error != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  describeError(context, state.error!),
                                  style: TextStyle(
                                      color: theme.colorScheme.error,
                                      fontSize: 12),
                                ),
                              ),
                            SafeArea(
                              top: false,
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _draftController,
                                        minLines: 1,
                                        maxLines: 3,
                                        maxLength: 1000,
                                        style: theme.textTheme.bodySmall,
                                        decoration: InputDecoration(
                                            hintText: l10n.aiChatPlaceholder,
                                            counterText: ''),
                                        onSubmitted: (_) => _send(),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.send, size: 20),
                                      onPressed: state.pending ? null : _send,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        PositionedDirectional(
          bottom: AiChatBubble._bottomOffset,
          end: 16,
          // `Semantics` instead of `FloatingActionButton.tooltip`: a
          // Material `Tooltip` needs an ancestor `Overlay`, but this
          // widget is mounted above the app's Navigator (in
          // `app/app.dart`'s `MaterialApp.builder`), outside the Overlay
          // the Navigator would otherwise provide.
          child: Semantics(
            button: true,
            label: _open ? l10n.aiChatCloseWidget : l10n.aiChatOpenWidget,
            child: FloatingActionButton(
              heroTag: 'aiChatBubble',
              onPressed: () => setState(() => _open = !_open),
              child: Icon(_open ? Icons.close : Icons.chat_bubble_outline),
            ),
          ),
        ),
      ],
    );
  }
}
