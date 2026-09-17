import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/observability/logger.dart';
import '../data/messaging_repository.dart';
import '../domain/message.dart';

/// Chat screen state: REST-loaded history plus whatever the WebSocket (or the
/// polling fallback) has appended since.
class ChatState {
  const ChatState({
    this.messages = const [],
    this.loading = true,
    this.live = false,
    this.sending = false,
    this.error,
  });

  final List<Message> messages;
  final bool loading;

  /// `true` while the WebSocket is connected; polling only runs while this is `false`.
  final bool live;
  final bool sending;
  final Object? error;

  ChatState copyWith({
    List<Message>? messages,
    bool? loading,
    bool? live,
    bool? sending,
    Object? error,
    bool clearError = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      loading: loading ?? this.loading,
      live: live ?? this.live,
      sending: sending ?? this.sending,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Mirrors `frontend/components/messaging/ChatWindow.tsx`: REST loads history
/// and sends messages; a `dart:io` `WebSocket` (opened with a single-use
/// ticket) delivers new messages live, pinging every 25s; a 15s REST poll is
/// the fallback whenever the socket is not currently open; reconnect backs off
/// exponentially up to 5 attempts.
class ChatController extends AutoDisposeFamilyNotifier<ChatState, String> {
  static const _pingInterval = Duration(seconds: 25);
  static const _pollInterval = Duration(seconds: 15);
  static const _maxReconnectAttempts = 5;

  Timer? _pingTimer;
  Timer? _pollTimer;
  Timer? _reconnectTimer;
  WebSocket? _socket;
  StreamSubscription<dynamic>? _socketSubscription;
  int _reconnectAttempts = 0;
  bool _disposed = false;

  String get _conversationId => arg;

  MessagingRepository get _repository => ref.read(messagingRepositoryProvider);

  @override
  ChatState build(String arg) {
    ref.onDispose(_disposeResources);
    unawaited(_loadHistory());
    unawaited(_connect());
    _startPolling();
    return const ChatState();
  }

  void _disposeResources() {
    _disposed = true;
    _pingTimer?.cancel();
    _pollTimer?.cancel();
    _reconnectTimer?.cancel();
    unawaited(_socketSubscription?.cancel());
    unawaited(_socket?.close());
  }

  Future<void> _loadHistory() async {
    try {
      final messages = await _repository.listMessages(_conversationId);
      if (_disposed) return;
      state = state.copyWith(messages: messages, loading: false, clearError: true);
    } on AppException catch (e) {
      if (_disposed) return;
      state = state.copyWith(loading: false, error: e);
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      if (!state.live) unawaited(_loadHistory());
    });
  }

  Future<void> _connect() async {
    if (_disposed) return;
    try {
      final ticket = await _repository.requestWsTicket();
      if (_disposed) return;
      final wsBaseUrl = ref.read(appConfigProvider).wsBaseUrl;
      final uri = Uri.parse('$wsBaseUrl/ws').replace(queryParameters: {'ticket': ticket.ticket});
      final socket = await WebSocket.connect(uri.toString());
      if (_disposed) {
        unawaited(socket.close());
        return;
      }
      _socket = socket;
      _reconnectAttempts = 0;
      state = state.copyWith(live: true);
      _pingTimer?.cancel();
      _pingTimer = Timer.periodic(_pingInterval, (_) => _sendPing());
      _socketSubscription = socket.listen(
        _onSocketData,
        onDone: _onSocketClosed,
        onError: (Object _) => socket.close(),
        cancelOnError: true,
      );
    } catch (e) {
      AppLogger.warn('chat websocket connect failed', tag: 'messaging', fields: {'reason': e.runtimeType});
      _scheduleReconnect();
    }
  }

  void _sendPing() {
    try {
      _socket?.add('ping');
    } catch (_) {
      // A dead socket will hit onError/onDone shortly; nothing else to do here.
    }
  }

  void _onSocketData(Object? data) {
    if (data is! String) return;
    try {
      final decoded = jsonDecode(data);
      if (decoded is! Map<String, dynamic> || decoded['type'] != 'message') return;
      final payload = decoded['message'];
      if (payload is! Map<String, dynamic>) return;
      final message = Message.fromJson(payload);
      if (message.conversationId == _conversationId) _appendMessage(message);
    } catch (e) {
      AppLogger.warn('could not decode chat frame', tag: 'messaging', fields: {'reason': e.runtimeType});
    }
  }

  void _appendMessage(Message message) {
    if (state.messages.any((m) => m.id == message.id)) return;
    state = state.copyWith(messages: [...state.messages, message]);
  }

  void _onSocketClosed() {
    _pingTimer?.cancel();
    _socket = null;
    if (_disposed) return;
    state = state.copyWith(live: false);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed || _reconnectAttempts >= _maxReconnectAttempts) return;
    _reconnectAttempts += 1;
    final delay = Duration(seconds: 1 << _reconnectAttempts); // 2s, 4s, 8s, 16s, 32s
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, _connect);
  }

  Future<void> sendMessage(String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty || state.sending) return;
    state = state.copyWith(sending: true, clearError: true);
    try {
      final message = await _repository.sendMessage(_conversationId, trimmed);
      _appendMessage(message);
      state = state.copyWith(sending: false);
    } on AppException catch (e) {
      state = state.copyWith(sending: false, error: e);
    }
  }

  Future<void> refresh() => _loadHistory();
}

final chatControllerProvider =
    NotifierProvider.autoDispose.family<ChatController, ChatState, String>(ChatController.new);
