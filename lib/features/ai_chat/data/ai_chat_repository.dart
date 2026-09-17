import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';

/// `ChatResponse` (Section 17 Phase 4 RAG chatbot). `sources` isn't rendered
/// on mobile (mirrors the web `AskChat`/`AskWidget`, which also don't show
/// them), so only `answer` is kept.
class AiChatReply {
  const AiChatReply({required this.answer});

  final String answer;

  factory AiChatReply.fromJson(Map<String, dynamic> json) =>
      AiChatReply(answer: json['answer'] as String? ?? '');
}

class AiChatRepository {
  AiChatRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  /// Works whether the caller is signed in or not - `ApiClient` only attaches
  /// a bearer token when one exists, and the backend accepts anonymous
  /// callers for this endpoint (Section 23 follow-up).
  Future<AiChatReply> ask(String message) async {
    final json = await _api.post(ApiPaths.aiChat, body: {'message': message});
    return AiChatReply.fromJson(asJsonObject(json));
  }
}

final aiChatRepositoryProvider = Provider<AiChatRepository>((ref) {
  return AiChatRepository(api: ref.watch(apiClientProvider));
});
