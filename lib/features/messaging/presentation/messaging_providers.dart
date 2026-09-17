import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/messaging_repository.dart';
import '../domain/conversation.dart';

final conversationsProvider = FutureProvider.autoDispose<List<Conversation>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(messagingRepositoryProvider).listConversations(cancelToken: cancelToken);
});

final conversationDetailProvider = FutureProvider.autoDispose.family<Conversation, String>((ref, id) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(messagingRepositoryProvider).getConversation(id, cancelToken: cancelToken);
});
