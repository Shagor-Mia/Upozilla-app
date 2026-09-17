import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/error/app_exception.dart';
import '../domain/contract.dart';
import '../domain/contract_payment.dart';
import '../domain/contract_problem.dart';
import '../domain/contract_progress.dart';

/// `GET /users/lookup?phone=` result — used by the create-contract screen to
/// resolve a phone number to a `worker_user_id` before submit.
class ContractWorkerLookup {
  const ContractWorkerLookup({required this.id, required this.fullName});

  final String id;
  final String fullName;

  factory ContractWorkerLookup.fromJson(Map<String, dynamic> json) => ContractWorkerLookup(
        id: json['id'] as String,
        fullName: json['full_name'] as String? ?? '',
      );
}

/// `POST /auth/ws-ticket` response — short-lived, single-use ticket that
/// authenticates the contract-updates WebSocket. Kept as a private copy
/// rather than importing `messaging`'s `WsTicket` so this feature doesn't
/// depend on a sibling feature's data layer.
class ContractWsTicket {
  const ContractWsTicket({required this.ticket, required this.expiresInSeconds});

  final String ticket;
  final int expiresInSeconds;

  factory ContractWsTicket.fromJson(Map<String, dynamic> json) => ContractWsTicket(
        ticket: json['ticket'] as String,
        expiresInSeconds: json['expires_in_seconds'] as int? ?? 60,
      );
}

/// `/contracts/*` and `/users/lookup` — the Work Contract module. Entirely
/// private/user-scoped data, so like `MessagingRepository` this is API-only
/// with no offline database.
class ContractsRepository {
  ContractsRepository({required ApiClient api}) : _api = api;

  final ApiClient _api;

  // --- create / read -----------------------------------------------------

  Future<WorkContract> createContract({
    required String workerUserId,
    required String title,
    required String description,
    required double paymentAmount,
    required String paymentType,
    String currency = 'BDT',
    DateTime? startDate,
    DateTime? endDate,
    List<String> referenceImages = const [],
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.contracts,
      body: {
        'worker_user_id': workerUserId,
        'title': title,
        'description': description,
        'payment_amount': paymentAmount,
        'payment_type': paymentType,
        'currency': currency,
        if (startDate != null) 'start_date': _dateOnly(startDate),
        if (endDate != null) 'end_date': _dateOnly(endDate),
        if (referenceImages.isNotEmpty) 'reference_images': referenceImages,
      },
      cancelToken: cancelToken,
    );
    return WorkContract.fromJson(asJsonObject(json));
  }

  /// `role`: `employer` | `worker` | null (both). `status`: a `ContractStatus`
  /// value, or null for all statuses.
  Future<List<WorkContract>> listMyContracts({
    String? role,
    String? status,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.get(
      ApiPaths.contractsMine,
      query: {'role': role, 'status': status},
      cancelToken: cancelToken,
    );
    return asJsonList(json).map(WorkContract.fromJson).toList();
  }

  Future<WorkContract> getContract(String id, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.contract(id), cancelToken: cancelToken);
    return WorkContract.fromJson(asJsonObject(json));
  }

  // --- lifecycle -----------------------------------------------------------

  Future<WorkContract> acceptContract(String id, {CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.contractAccept(id), cancelToken: cancelToken);
    return WorkContract.fromJson(asJsonObject(json));
  }

  Future<WorkContract> rejectContract(String id, {String? reason, CancelToken? cancelToken}) async {
    final json = await _api.post(
      ApiPaths.contractReject(id),
      body: {if (reason != null && reason.isNotEmpty) 'reason': reason},
      cancelToken: cancelToken,
    );
    return WorkContract.fromJson(asJsonObject(json));
  }

  Future<WorkContract> cancelContract(String id, {required String reason, CancelToken? cancelToken}) async {
    final json = await _api.post(
      ApiPaths.contractCancel(id),
      body: {'reason': reason},
      cancelToken: cancelToken,
    );
    return WorkContract.fromJson(asJsonObject(json));
  }

  Future<WorkContract> completeContract(String id, {CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.contractComplete(id), cancelToken: cancelToken);
    return WorkContract.fromJson(asJsonObject(json));
  }

  // --- progress --------------------------------------------------------------

  Future<List<ContractProgressEntry>> listProgress(String contractId, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.contractProgress(contractId), cancelToken: cancelToken);
    return asJsonList(json).map(ContractProgressEntry.fromJson).toList();
  }

  Future<ContractProgressEntry> logProgress(
    String contractId, {
    required String note,
    int? percentComplete,
    List<String> images = const [],
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.contractProgress(contractId),
      body: {
        'note': note,
        if (percentComplete != null) 'percent_complete': percentComplete,
        if (images.isNotEmpty) 'images': images,
      },
      cancelToken: cancelToken,
    );
    return ContractProgressEntry.fromJson(asJsonObject(json));
  }

  // --- payments ------------------------------------------------------------

  Future<List<ContractPayment>> listPayments(String contractId, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.contractPayments(contractId), cancelToken: cancelToken);
    return asJsonList(json).map(ContractPayment.fromJson).toList();
  }

  Future<ContractPayment> logPayment(
    String contractId, {
    required double amount,
    required String method,
    String? note,
    List<String> proofImages = const [],
    DateTime? paidAt,
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.contractPayments(contractId),
      body: {
        'amount': amount,
        'method': method,
        if (note != null && note.isNotEmpty) 'note': note,
        if (proofImages.isNotEmpty) 'proof_images': proofImages,
        if (paidAt != null) 'paid_at': paidAt.toIso8601String(),
      },
      cancelToken: cancelToken,
    );
    return ContractPayment.fromJson(asJsonObject(json));
  }

  Future<ContractPayment> confirmPayment(String contractId, String paymentId, {CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.contractPaymentConfirm(contractId, paymentId), cancelToken: cancelToken);
    return ContractPayment.fromJson(asJsonObject(json));
  }

  // --- problems / disputes ----------------------------------------------------

  Future<List<ContractProblem>> listProblems(String contractId, {CancelToken? cancelToken}) async {
    final json = await _api.get(ApiPaths.contractProblems(contractId), cancelToken: cancelToken);
    return asJsonList(json).map(ContractProblem.fromJson).toList();
  }

  Future<ContractProblem> reportProblem(
    String contractId, {
    required String category,
    required String description,
    List<String> images = const [],
    CancelToken? cancelToken,
  }) async {
    final json = await _api.post(
      ApiPaths.contractProblems(contractId),
      body: {
        'category': category,
        'description': description,
        if (images.isNotEmpty) 'images': images,
      },
      cancelToken: cancelToken,
    );
    return ContractProblem.fromJson(asJsonObject(json));
  }

  Future<ContractProblem> resolveProblem(String contractId, String problemId, {CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.contractProblemResolve(contractId, problemId), cancelToken: cancelToken);
    return ContractProblem.fromJson(asJsonObject(json));
  }

  Future<ContractProblem> escalateProblem(String contractId, String problemId, {CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.contractProblemEscalate(contractId, problemId), cancelToken: cancelToken);
    return ContractProblem.fromJson(asJsonObject(json));
  }

  // --- worker lookup / realtime ticket ----------------------------------------

  /// Resolves a phone number to a registered user, or `null` on a 404 (no
  /// such user) so the create-contract screen can show `workerNotFound`
  /// instead of a generic error.
  Future<ContractWorkerLookup?> lookupWorkerByPhone(String phone, {CancelToken? cancelToken}) async {
    try {
      final json = await _api.get(ApiPaths.userLookup, query: {'phone': phone}, cancelToken: cancelToken);
      return ContractWorkerLookup.fromJson(asJsonObject(json));
    } on NotFoundException {
      return null;
    }
  }

  Future<ContractWsTicket> requestWsTicket({CancelToken? cancelToken}) async {
    final json = await _api.post(ApiPaths.authWsTicket, cancelToken: cancelToken);
    return ContractWsTicket.fromJson(asJsonObject(json));
  }

  static String _dateOnly(DateTime value) =>
      '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}

final contractsRepositoryProvider = Provider<ContractsRepository>((ref) {
  return ContractsRepository(api: ref.watch(apiClientProvider));
});
