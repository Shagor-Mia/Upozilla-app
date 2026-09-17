import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../data/ai_chat_repository.dart';

class ChatTurn {
  const ChatTurn({required this.question, required this.answer});

  final String question;
  final String answer;
}

class AiChatState {
  const AiChatState({this.turns = const [], this.pending = false, this.error});

  final List<ChatTurn> turns;
  final bool pending;
  final Object? error;

  AiChatState copyWith({List<ChatTurn>? turns, bool? pending, Object? error, bool clearError = false}) {
    return AiChatState(
      turns: turns ?? this.turns,
      pending: pending ?? this.pending,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Section 17 Phase 4 RAG chatbot - single-turn per question (the backend is
/// stateless per call), same shared logic mirrored by
/// `frontend/components/ai/useAskChat.ts`. **One single global instance**
/// (not `.autoDispose`, not a `.family`): the floating bubble
/// (`ai_chat_bubble.dart`) is mounted for the app's entire lifetime, so a
/// question asked there is still visible if the user then opens the full
/// `AiChatScreen` - a deliberate improvement the persistent-overlay
/// architecture makes easy, not just parity with the web.
class AiChatController extends Notifier<AiChatState> {
  AiChatRepository get _repository => ref.read(aiChatRepositoryProvider);

  @override
  AiChatState build() => const AiChatState();

  Future<void> sendMessage(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty || state.pending) return;
    state = state.copyWith(pending: true, clearError: true);
    try {
      final reply = await _repository.ask(trimmed);
      state = state.copyWith(
        turns: [...state.turns, ChatTurn(question: trimmed, answer: reply.answer)],
        pending: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(pending: false, error: e);
    }
  }
}

final aiChatControllerProvider = NotifierProvider<AiChatController, AiChatState>(AiChatController.new);
