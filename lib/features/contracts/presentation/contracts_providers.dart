import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/contracts_repository.dart';
import '../domain/contract.dart';
import '../domain/contract_payment.dart';
import '../domain/contract_problem.dart';
import '../domain/contract_progress.dart';

CancelToken _cancelOnDispose(Ref<Object?> ref) {
  final token = CancelToken();
  ref.onDispose(token.cancel);
  return token;
}

/// Keyed by role filter (`null` = all, `employer`, `worker`) so the "My
/// Contracts" screen's filter chips are just a different provider argument.
final myContractsProvider = FutureProvider.autoDispose.family<List<WorkContract>, String?>((ref, role) {
  return ref.watch(contractsRepositoryProvider).listMyContracts(role: role, cancelToken: _cancelOnDispose(ref));
});

final contractDetailProvider = FutureProvider.autoDispose.family<WorkContract, String>((ref, id) {
  return ref.watch(contractsRepositoryProvider).getContract(id, cancelToken: _cancelOnDispose(ref));
});

final contractProgressProvider = FutureProvider.autoDispose.family<List<ContractProgressEntry>, String>(
  (ref, contractId) {
    return ref.watch(contractsRepositoryProvider).listProgress(contractId, cancelToken: _cancelOnDispose(ref));
  },
);

final contractPaymentsProvider = FutureProvider.autoDispose.family<List<ContractPayment>, String>(
  (ref, contractId) {
    return ref.watch(contractsRepositoryProvider).listPayments(contractId, cancelToken: _cancelOnDispose(ref));
  },
);

final contractProblemsProvider = FutureProvider.autoDispose.family<List<ContractProblem>, String>(
  (ref, contractId) {
    return ref.watch(contractsRepositoryProvider).listProblems(contractId, cancelToken: _cancelOnDispose(ref));
  },
);
