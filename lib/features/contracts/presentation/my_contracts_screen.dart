import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/online_only_gate.dart';
import 'contracts_providers.dart';
import 'widgets/contract_card.dart';

/// `GET /contracts/mine?role=` list, filtered client-side-triggered by role
/// chips (All / Employer / Worker) which simply re-key `myContractsProvider`.
class MyContractsScreen extends ConsumerStatefulWidget {
  const MyContractsScreen({super.key});

  @override
  ConsumerState<MyContractsScreen> createState() => _MyContractsScreenState();
}

class _MyContractsScreenState extends ConsumerState<MyContractsScreen> {
  /// `null` (all) | `employer` | `worker`
  String? _role;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currentUserId = ref.watch(authControllerProvider).valueOrNull?.user?.id;
    final value = ref.watch(myContractsProvider(_role));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myContractsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.createContract),
        child: const Icon(Icons.add),
      ),
      // Contracts are private/user-scoped and API-only (Section: offline-first
      // plan) - gate the whole screen instead of a generic error on load,
      // mirroring marketplace/messaging/ai_chat.
      body: OnlineOnlyGate(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.contractRoleAll),
                    selected: _role == null,
                    onSelected: (_) => setState(() => _role = null),
                  ),
                  ChoiceChip(
                    label: Text(l10n.contractRoleEmployer),
                    selected: _role == 'employer',
                    onSelected: (_) => setState(() => _role = 'employer'),
                  ),
                  ChoiceChip(
                    label: Text(l10n.contractRoleWorker),
                    selected: _role == 'worker',
                    onSelected: (_) => setState(() => _role = 'worker'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AsyncValueWidget(
                value: value,
                onRetry: () => ref.invalidate(myContractsProvider(_role)),
                data: (contracts) {
                  if (contracts.isEmpty) return EmptyState(title: l10n.noContractsYet);
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: contracts.length,
                    itemBuilder: (context, index) =>
                        ContractCard(contract: contracts[index], currentUserId: currentUserId),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
