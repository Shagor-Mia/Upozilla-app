import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/observability/logger.dart';
import '../data/contracts_repository.dart';
import '../domain/contract.dart';
import '../domain/contract_payment.dart';
import '../domain/contract_problem.dart';
import '../domain/contract_progress.dart';

/// Contract detail screen state: the contract itself plus its three
/// sub-resource lists, refreshed either by the WebSocket, the poll fallback,
/// or an explicit `refresh()` after the viewer takes an action.
class ContractDetailState {
  const ContractDetailState({
    this.contract,
    this.progress = const [],
    this.payments = const [],
    this.problems = const [],
    this.loading = true,
    this.live = false,
    this.error,
  });

  final WorkContract? contract;
  final List<ContractProgressEntry> progress;
  final List<ContractPayment> payments;
  final List<ContractProblem> problems;
  final bool loading;

  /// `true` while the WebSocket is connected; polling only runs while this is `false`.
  final bool live;
  final Object? error;

  ContractDetailState copyWith({
    WorkContract? contract,
    List<ContractProgressEntry>? progress,
    List<ContractPayment>? payments,
    List<ContractProblem>? problems,
    bool? loading,
    bool? live,
    Object? error,
    bool clearError = false,
  }) {
    return ContractDetailState(
      contract: contract ?? this.contract,
      progress: progress ?? this.progress,
      payments: payments ?? this.payments,
      problems: problems ?? this.problems,
      loading: loading ?? this.loading,
      live: live ?? this.live,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Mirrors `messaging/presentation/chat_controller.dart`'s `ChatController`:
/// REST loads the full detail state; a `dart:io` `WebSocket` (opened with a
/// single-use ticket) delivers `contract_update` frames live, pinging every
/// 25s; a 15s REST poll is the fallback whenever the socket is not currently
/// open; reconnect backs off exponentially up to 5 attempts. Each WS event
/// only re-fetches the sub-resource it affects rather than the whole state.
class ContractDetailController extends AutoDisposeFamilyNotifier<ContractDetailState, String> {
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

  String get _contractId => arg;

  ContractsRepository get _repository => ref.read(contractsRepositoryProvider);

  @override
  ContractDetailState build(String arg) {
    ref.onDispose(_disposeResources);
    unawaited(_loadAll());
    unawaited(_connect());
    _startPolling();
    return const ContractDetailState();
  }

  void _disposeResources() {
    _disposed = true;
    _pingTimer?.cancel();
    _pollTimer?.cancel();
    _reconnectTimer?.cancel();
    unawaited(_socketSubscription?.cancel());
    unawaited(_socket?.close());
  }

  Future<void> _loadAll() async {
    try {
      final contract = await _repository.getContract(_contractId);
      final progress = await _repository.listProgress(_contractId);
      final payments = await _repository.listPayments(_contractId);
      final problems = await _repository.listProblems(_contractId);
      if (_disposed) return;
      state = state.copyWith(
        contract: contract,
        progress: progress,
        payments: payments,
        problems: problems,
        loading: false,
        clearError: true,
      );
    } on AppException catch (e) {
      if (_disposed) return;
      state = state.copyWith(loading: false, error: e);
    }
  }

  /// Public so the detail screen can re-fetch the narrowest affected
  /// resource right after a successful action (accept/cancel/etc.) without
  /// waiting for the poll or a WS echo.
  Future<void> refetchContract() async {
    try {
      final contract = await _repository.getContract(_contractId);
      if (_disposed) return;
      state = state.copyWith(contract: contract);
    } on AppException catch (_) {
      // The next poll/WS event will retry; nothing actionable here.
    }
  }

  Future<void> refetchProgress() async {
    try {
      final progress = await _repository.listProgress(_contractId);
      if (_disposed) return;
      state = state.copyWith(progress: progress);
    } on AppException catch (_) {}
  }

  Future<void> refetchPayments() async {
    try {
      final payments = await _repository.listPayments(_contractId);
      if (_disposed) return;
      state = state.copyWith(payments: payments);
    } on AppException catch (_) {}
  }

  Future<void> refetchProblems() async {
    try {
      final problems = await _repository.listProblems(_contractId);
      if (_disposed) return;
      state = state.copyWith(problems: problems);
    } on AppException catch (_) {}
  }

  Future<void> refresh() => _loadAll();

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      if (!state.live) unawaited(_loadAll());
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
      AppLogger.warn('contract websocket connect failed', tag: 'contracts', fields: {'reason': e.runtimeType});
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
      if (decoded is! Map<String, dynamic> || decoded['type'] != 'contract_update') return;
      if (decoded['contract_id'] != _contractId) return;
      switch (decoded['event']) {
        case 'accepted':
          unawaited(refetchContract());
        case 'payment_logged':
          unawaited(refetchPayments());
        case 'problem_reported':
          unawaited(refetchProblems());
        case 'dispute_resolved':
          // A ruling can also transition the contract itself (auto-cancel or
          // back to active), so refresh both.
          unawaited(refetchContract());
          unawaited(refetchProblems());
        default:
          unawaited(_loadAll());
      }
    } catch (e) {
      AppLogger.warn('could not decode contract update frame', tag: 'contracts', fields: {'reason': e.runtimeType});
    }
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
}

final contractDetailControllerProvider =
    NotifierProvider.autoDispose.family<ContractDetailController, ContractDetailState, String>(
  ContractDetailController.new,
);
