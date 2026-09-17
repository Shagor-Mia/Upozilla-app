import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../domain/conversation.dart';
import '../domain/message.dart';

/// `POST /auth/ws-ticket` response — a short-lived, single-use ticket that
/// authenticates the messaging WebSocket (the JWT itself is never put on a
/// query string).
class WsTicket {
  const WsTicket({required this.ticket, required this.expiresInSeconds});

  final String ticket;
  final int expiresInSeconds;

  factory WsTicket.fromJson(Map<String, dynamic> json) => WsTicket(
        ticket: json['ticket'] as String,
        expiresInSeconds: json['expires_in_seconds'] as int? ?? 60,
      );
}

/// `/conversations/*` and the ticket mint for `/ws`. History and sends go
/// over REST; the WebSocket (see `chat_controller.dart`) is delivery-only.
class MessagingRepository {
  MessagingRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  Future<List<Conversation>> listConversations({CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.conversations, cancelToken: cancelToken);
    return asJsonList(json).map(Conversation.fromJson).toList();
  }

  Future<Conversation> getConversation(String id, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.conversation(id), cancelToken: cancelToken);
    return Conversation.fromJson(asJsonObject(json));
  }

  Future<List<Message>> listMessages(String conversationId, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.conversationMessages(conversationId), cancelToken: cancelToken);
    return asJsonList(json).map(Message.fromJson).toList();
  }

  Future<Message> sendMessage(String conversationId, String body, {CancelToken? cancelToken}) async {
    final json = await _api.post(
      ApiPaths.conversationMessages(conversationId),
      body: {'body': body},
      cancelToken: cancelToken,
    );
    return Message.fromJson(asJsonObject(json));
  }

  /// Requires phone verification server-side.
  Future<Conversation> startConversation({
    required String listingType,
    required String listingId,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.conversations,
      body: {'listing_type': listingType, 'listing_id': listingId},
      cancelToken: cancelToken,
    );
    return Conversation.fromJson(asJsonObject(json));
  }

  Future<WsTicket> requestWsTicket({CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.authWsTicket, cancelToken: cancelToken);
    return WsTicket.fromJson(asJsonObject(json));
  }
}

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepository(api: ref.watch(apiClientProvider));
});
