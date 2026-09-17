import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/remote_image.dart';
import '../../../core/widgets/snackbars.dart';
import '../data/contracts_repository.dart';
import '../domain/contract.dart';
import '../domain/contract_payment.dart';
import '../domain/contract_problem.dart';
import '../domain/contract_progress.dart';
import 'contract_detail_controller.dart';

/// Header (parties, status chip, action buttons gated by role+status) plus a
/// `DefaultTabController(length: 3)` body (Progress/Payments/Problems),
/// copying `my_listings_screen.dart`'s tab structure. Live updates come from
/// `ContractDetailController` (WS + poll fallback).
class ContractDetailScreen extends ConsumerWidget {
  const ContractDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(contractDetailControllerProvider(id));
    final currentUserId = ref.watch(authControllerProvider).valueOrNull?.user?.id;
    final contract = state.contract;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(contract?.title ?? l10n.contractDetailTitle),
          bottom: contract == null
              ? null
              : TabBar(
                  tabs: [
                    Tab(text: l10n.contractTabProgress),
                    Tab(text: l10n.contractTabPayments),
                    Tab(text: l10n.contractTabProblems),
                  ],
                ),
        ),
        body: _buildBody(context, ref, state, contract, currentUserId),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ContractDetailState state,
    WorkContract? contract,
    String? currentUserId,
  ) {
    final l10n = context.l10n;
    if (contract == null) {
      if (state.loading) return const Center(child: CircularProgressIndicator());
      if (state.error != null) {
        return ErrorState(
          message: describeError(context, state.error!),
          isOffline: state.error is OfflineException,
          onRetry: () => ref.read(contractDetailControllerProvider(id).notifier).refresh(),
        );
      }
      return EmptyState(title: l10n.contractDetailTitle);
    }
    return Column(
      children: [
        _ContractHeader(contract: contract, currentUserId: currentUserId, live: state.live),
        const Divider(height: 1),
        Expanded(
          child: TabBarView(
            children: [
              _ProgressTab(contractId: id, contract: contract, entries: state.progress, currentUserId: currentUserId),
              _PaymentsTab(contractId: id, contract: contract, payments: state.payments, currentUserId: currentUserId),
              _ProblemsTab(contractId: id, contract: contract, problems: state.problems, currentUserId: currentUserId),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContractHeader extends ConsumerWidget {
  const _ContractHeader({required this.contract, required this.currentUserId, required this.live});

  final WorkContract contract;
  final String? currentUserId;
  final bool live;

  Color? _statusColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return switch (contract.status) {
      'active' => Colors.green.shade100,
      'completed' => scheme.primaryContainer,
      'rejected' || 'cancelled' => scheme.errorContainer,
      'disputed' => Colors.amber.shade100,
      _ => scheme.surfaceContainerHighest,
    };
  }

  String _statusLabel(AppLocalizations l10n) => switch (contract.status) {
        'active' => l10n.contractStatusActive,
        'rejected' => l10n.contractStatusRejected,
        'cancelled' => l10n.contractStatusCancelled,
        'disputed' => l10n.contractStatusDisputed,
        'completed' => l10n.contractStatusCompleted,
        _ => l10n.contractStatusPending,
      };

  Future<void> _accept(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(contractsRepositoryProvider).acceptContract(contract.id);
      await ref.read(contractDetailControllerProvider(contract.id).notifier).refetchContract();
      if (context.mounted) showMessageSnackBar(context, context.l10n.contractAccepted);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  Future<void> _reject(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final reason = await _promptForText(
      context,
      title: l10n.contractRejectTitle,
      label: l10n.contractRejectReasonLabel,
      actionLabel: l10n.contractReject,
      requireNonEmpty: false,
    );
    if (reason == null) return;
    try {
      await ref.read(contractsRepositoryProvider).rejectContract(contract.id, reason: reason);
      await ref.read(contractDetailControllerProvider(contract.id).notifier).refetchContract();
      if (context.mounted) showMessageSnackBar(context, l10n.contractRejected);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final reason = await _promptForText(
      context,
      title: l10n.contractCancelTitle,
      label: l10n.contractCancelReasonLabel,
      actionLabel: l10n.contractCancel,
      requireNonEmpty: true,
    );
    if (reason == null) return;
    try {
      await ref.read(contractsRepositoryProvider).cancelContract(contract.id, reason: reason);
      await ref.read(contractDetailControllerProvider(contract.id).notifier).refetchContract();
      if (context.mounted) showMessageSnackBar(context, l10n.contractCancelled);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  Future<void> _complete(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(contractsRepositoryProvider).completeContract(contract.id);
      await ref.read(contractDetailControllerProvider(contract.id).notifier).refetchContract();
      if (context.mounted) showMessageSnackBar(context, context.l10n.contractCompleted);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isEmployer = contract.isEmployer(currentUserId);
    final isWorker = contract.isWorker(currentUserId);
    final isParty = isEmployer || isWorker;

    final actions = <Widget>[];
    if (isWorker && contract.status == 'pending') {
      actions
        ..add(FilledButton(onPressed: () => _accept(context, ref), child: Text(l10n.contractAccept)))
        ..add(OutlinedButton(onPressed: () => _reject(context, ref), child: Text(l10n.contractReject)));
    }
    if (isParty && (contract.status == 'pending' || contract.status == 'active')) {
      actions.add(OutlinedButton(onPressed: () => _cancel(context, ref), child: Text(l10n.contractCancel)));
    }
    if (isParty && contract.status == 'active') {
      final alreadyConfirmed = contract.hasConfirmedCompletion(currentUserId);
      actions.add(
        FilledButton(
          onPressed: alreadyConfirmed ? null : () => _complete(context, ref),
          child: Text(alreadyConfirmed ? l10n.contractWaitingOtherCompletion : l10n.contractMarkComplete),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(contract.title, style: theme.textTheme.titleLarge),
              ),
              Chip(
                label: Text(_statusLabel(l10n)),
                backgroundColor: _statusColor(context),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(contract.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          _InfoRow(label: l10n.contractEmployerLabel, value: contract.employerName ?? '-'),
          _InfoRow(label: l10n.contractWorkerLabel, value: contract.workerName ?? '-'),
          _InfoRow(
            label: l10n.contractPaymentAmountLabel,
            value: Formatters.price(contract.paymentAmount, currency: contract.currency),
          ),
          if (contract.startDate != null || contract.endDate != null)
            _InfoRow(
              label: l10n.contractDurationLabel,
              value: [
                if (contract.startDate != null) Formatters.date(contract.startDate!),
                if (contract.endDate != null) Formatters.date(contract.endDate!),
              ].join(' — '),
            ),
          if (contract.cancellationReason != null && contract.cancellationReason!.isNotEmpty)
            _InfoRow(label: l10n.contractCancelReasonLabel, value: contract.cancellationReason!),
          if (contract.referenceImages.isNotEmpty) ...[
            const SizedBox(height: 8),
            _ImageStrip(images: contract.referenceImages),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: actions),
          ],
          if (!live) ...[
            const SizedBox(height: 8),
            Text(l10n.chatPolling, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 96, child: Text(label, style: theme.textTheme.bodySmall)),
          Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _ImageStrip extends StatelessWidget {
  const _ImageStrip({required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) => RemoteImage(
          url: images[index],
          width: 48,
          height: 48,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}

/// Simple single-line text prompt shared by reject/cancel.
Future<String?> _promptForText(
  BuildContext context, {
  required String title,
  required String label,
  required String actionLabel,
  required bool requireNonEmpty,
}) {
  final l10n = context.l10n;
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          maxLines: 2,
          decoration: InputDecoration(labelText: label),
          validator: requireNonEmpty
              ? (value) => (value == null || value.trim().isEmpty) ? l10n.contractCancelReasonRequired : null
              : null,
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () {
            if (!(formKey.currentState?.validate() ?? true)) return;
            Navigator.of(dialogContext).pop(controller.text.trim());
          },
          child: Text(actionLabel),
        ),
      ],
    ),
  );
}

// --- Progress tab ------------------------------------------------------------

class _ProgressTab extends ConsumerWidget {
  const _ProgressTab({required this.contractId, required this.contract, required this.entries, required this.currentUserId});

  final String contractId;
  final WorkContract contract;
  final List<ContractProgressEntry> entries;
  final String? currentUserId;

  bool get _canLog =>
      contract.status == 'active' && (contract.isEmployer(currentUserId) || contract.isWorker(currentUserId));

  Future<void> _logProgress(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<_ProgressInput>(
      context: context,
      builder: (_) => const _LogProgressDialog(),
    );
    if (result == null) return;
    try {
      await ref.read(contractsRepositoryProvider).logProgress(
            contractId,
            note: result.note,
            percentComplete: result.percentComplete,
            images: result.images,
          );
      await ref.read(contractDetailControllerProvider(contractId).notifier).refetchProgress();
      if (context.mounted) showMessageSnackBar(context, context.l10n.contractProgressLogged);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButton: _canLog
          ? FloatingActionButton.extended(
              onPressed: () => _logProgress(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.contractLogProgress),
            )
          : null,
      body: entries.isEmpty
          ? EmptyState(title: l10n.contractProgressEmpty)
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: entries.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  title: Text(entry.note),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text([
                        if (entry.createdByName != null) entry.createdByName!,
                        if (entry.percentComplete != null) '${entry.percentComplete}%',
                        if (entry.createdAt != null) Formatters.dateTime(entry.createdAt!),
                      ].join(' · ')),
                      if (entry.images.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _ImageStrip(images: entry.images),
                      ],
                    ],
                  ),
                  isThreeLine: entry.images.isNotEmpty,
                );
              },
            ),
    );
  }
}

class _ProgressInput {
  const _ProgressInput({required this.note, this.percentComplete, this.images = const []});

  final String note;
  final int? percentComplete;
  final List<String> images;
}

class _LogProgressDialog extends StatefulWidget {
  const _LogProgressDialog();

  @override
  State<_LogProgressDialog> createState() => _LogProgressDialogState();
}

class _LogProgressDialogState extends State<_LogProgressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  final _percentController = TextEditingController();
  final _imagesController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    _percentController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.contractLogProgress),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _noteController,
                autofocus: true,
                maxLines: 3,
                decoration: InputDecoration(labelText: l10n.contractProgressNoteField),
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.contractDescriptionTooShort : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _percentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.contractProgressPercentField),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imagesController,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.contractProgressImagesField),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            final percent = int.tryParse(_percentController.text.trim());
            final images = _imagesController.text
                .split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList();
            Navigator.of(context).pop(
              _ProgressInput(note: _noteController.text.trim(), percentComplete: percent, images: images),
            );
          },
          child: Text(l10n.contractLogProgress),
        ),
      ],
    );
  }
}

// --- Payments tab ------------------------------------------------------------

class _PaymentsTab extends ConsumerWidget {
  const _PaymentsTab({required this.contractId, required this.contract, required this.payments, required this.currentUserId});

  final String contractId;
  final WorkContract contract;
  final List<ContractPayment> payments;
  final String? currentUserId;

  bool get _canLog =>
      contract.status == 'active' && (contract.isEmployer(currentUserId) || contract.isWorker(currentUserId));

  Future<void> _logPayment(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<_PaymentInput>(context: context, builder: (_) => const _LogPaymentDialog());
    if (result == null) return;
    try {
      await ref.read(contractsRepositoryProvider).logPayment(
            contractId,
            amount: result.amount,
            method: result.method,
            note: result.note,
            proofImages: result.images,
          );
      await ref.read(contractDetailControllerProvider(contractId).notifier).refetchPayments();
      if (context.mounted) showMessageSnackBar(context, context.l10n.contractPaymentLogged);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref, ContractPayment payment) async {
    try {
      await ref.read(contractsRepositoryProvider).confirmPayment(contractId, payment.id);
      await ref.read(contractDetailControllerProvider(contractId).notifier).refetchPayments();
      if (context.mounted) showMessageSnackBar(context, context.l10n.contractPaymentConfirmed);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButton: _canLog
          ? FloatingActionButton.extended(
              onPressed: () => _logPayment(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.contractLogPayment),
            )
          : null,
      body: payments.isEmpty
          ? EmptyState(title: l10n.contractPaymentsEmpty)
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: payments.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final payment = payments[index];
                final canConfirm = payment.status == 'pending_confirmation' && payment.loggedByUserId != currentUserId;
                return ListTile(
                  title: Text(Formatters.price(payment.amount, currency: contract.currency)),
                  subtitle: Text([
                    _paymentMethodLabel(l10n, payment.method),
                    payment.isConfirmed ? l10n.contractPaymentStatusConfirmed : l10n.contractPaymentStatusPendingConfirmation,
                    if (payment.note != null && payment.note!.isNotEmpty) payment.note!,
                    if (payment.paidAt != null) Formatters.dateTime(payment.paidAt!),
                  ].join(' · ')),
                  trailing: canConfirm
                      ? TextButton(onPressed: () => _confirm(context, ref, payment), child: Text(l10n.contractConfirmPayment))
                      : null,
                );
              },
            ),
    );
  }

  String _paymentMethodLabel(AppLocalizations l10n, String method) => switch (method) {
        'bkash' => l10n.contractPaymentMethodBkash,
        'nagad' => l10n.contractPaymentMethodNagad,
        'bank' => l10n.contractPaymentMethodBank,
        'other' => l10n.contractPaymentMethodOther,
        _ => l10n.contractPaymentMethodCash,
      };
}

class _PaymentInput {
  const _PaymentInput({required this.amount, required this.method, this.note, this.images = const []});

  final double amount;
  final String method;
  final String? note;
  final List<String> images;
}

class _LogPaymentDialog extends StatefulWidget {
  const _LogPaymentDialog();

  @override
  State<_LogPaymentDialog> createState() => _LogPaymentDialogState();
}

class _LogPaymentDialogState extends State<_LogPaymentDialog> {
  static const _methods = ['cash', 'bkash', 'nagad', 'bank', 'other'];

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _imagesController = TextEditingController();
  String _method = 'cash';

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  String _methodLabel(AppLocalizations l10n, String method) => switch (method) {
        'bkash' => l10n.contractPaymentMethodBkash,
        'nagad' => l10n.contractPaymentMethodNagad,
        'bank' => l10n.contractPaymentMethodBank,
        'other' => l10n.contractPaymentMethodOther,
        _ => l10n.contractPaymentMethodCash,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.contractLogPayment),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _amountController,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.contractPaymentAmountField),
                validator: (value) {
                  final parsed = double.tryParse((value ?? '').trim());
                  return (parsed == null || parsed <= 0) ? l10n.contractPaymentAmountInvalid : null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _method,
                decoration: InputDecoration(labelText: l10n.contractPaymentMethodField),
                items: _methods.map((m) => DropdownMenuItem(value: m, child: Text(_methodLabel(l10n, m)))).toList(),
                onChanged: (value) => setState(() => _method = value ?? _method),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.contractPaymentNoteField),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imagesController,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.contractPaymentProofImagesField),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            final images = _imagesController.text
                .split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList();
            Navigator.of(context).pop(
              _PaymentInput(
                amount: double.parse(_amountController.text.trim()),
                method: _method,
                note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                images: images,
              ),
            );
          },
          child: Text(l10n.contractLogPayment),
        ),
      ],
    );
  }
}

// --- Problems tab ------------------------------------------------------------

class _ProblemsTab extends ConsumerWidget {
  const _ProblemsTab({required this.contractId, required this.contract, required this.problems, required this.currentUserId});

  final String contractId;
  final WorkContract contract;
  final List<ContractProblem> problems;
  final String? currentUserId;

  bool get _canReport =>
      contract.status == 'active' && (contract.isEmployer(currentUserId) || contract.isWorker(currentUserId));

  Future<void> _reportProblem(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<_ProblemInput>(context: context, builder: (_) => const _ReportProblemDialog());
    if (result == null) return;
    try {
      await ref.read(contractsRepositoryProvider).reportProblem(
            contractId,
            category: result.category,
            description: result.description,
            images: result.images,
          );
      await ref.read(contractDetailControllerProvider(contractId).notifier).refetchProblems();
      if (context.mounted) showMessageSnackBar(context, context.l10n.contractProblemReported);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  Future<void> _resolve(BuildContext context, WidgetRef ref, ContractProblem problem) async {
    try {
      await ref.read(contractsRepositoryProvider).resolveProblem(contractId, problem.id);
      await ref.read(contractDetailControllerProvider(contractId).notifier).refetchProblems();
      if (context.mounted) showMessageSnackBar(context, context.l10n.contractProblemResolved);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  Future<void> _escalate(BuildContext context, WidgetRef ref, ContractProblem problem) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.contractEscalateConfirmTitle),
        content: Text(l10n.contractEscalateConfirmBody),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.of(dialogContext).pop(true), child: Text(l10n.contractEscalateProblem)),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(contractsRepositoryProvider).escalateProblem(contractId, problem.id);
      final notifier = ref.read(contractDetailControllerProvider(contractId).notifier);
      await notifier.refetchProblems();
      await notifier.refetchContract();
      if (context.mounted) showMessageSnackBar(context, l10n.contractProblemEscalated);
    } on AppException catch (e) {
      if (context.mounted) showErrorSnackBar(context, e);
    }
  }

  String _categoryLabel(AppLocalizations l10n, String category) => switch (category) {
        'scope_disagreement' => l10n.contractProblemCategoryScopeDisagreement,
        'payment_issue' => l10n.contractProblemCategoryPaymentIssue,
        'quality_issue' => l10n.contractProblemCategoryQualityIssue,
        'no_show' => l10n.contractProblemCategoryNoShow,
        _ => l10n.contractProblemCategoryOther,
      };

  String _statusLabel(AppLocalizations l10n, String status) => switch (status) {
        'resolved' => l10n.contractProblemStatusResolved,
        'escalated' => l10n.contractProblemStatusEscalated,
        'dispute_resolved' => l10n.contractProblemStatusDisputeResolved,
        _ => l10n.contractProblemStatusOpen,
      };

  String? _resolutionLabel(AppLocalizations l10n, String? resolution) => switch (resolution) {
        'favor_employer' => l10n.contractDisputeFavorEmployer,
        'favor_worker' => l10n.contractDisputeFavorWorker,
        'dismissed' => l10n.contractDisputeDismissed,
        _ => null,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      floatingActionButton: _canReport
          ? FloatingActionButton.extended(
              onPressed: () => _reportProblem(context, ref),
              icon: const Icon(Icons.report_problem_outlined),
              label: Text(l10n.contractReportProblem),
            )
          : null,
      body: problems.isEmpty
          ? EmptyState(title: l10n.contractProblemsEmpty)
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: problems.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final problem = problems[index];
                final resolutionLabel = _resolutionLabel(l10n, problem.resolution);
                return ListTile(
                  title: Text(_categoryLabel(l10n, problem.category)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(problem.description),
                      const SizedBox(height: 4),
                      Text(_statusLabel(l10n, problem.status)),
                      if (resolutionLabel != null) Text(resolutionLabel),
                      if (problem.resolutionNote != null && problem.resolutionNote!.isNotEmpty)
                        Text('${l10n.contractResolutionNoteLabel}: ${problem.resolutionNote}'),
                      if (problem.images.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        _ImageStrip(images: problem.images),
                      ],
                    ],
                  ),
                  isThreeLine: true,
                  trailing: problem.isOpen
                      ? PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'resolve') _resolve(context, ref, problem);
                            if (value == 'escalate') _escalate(context, ref, problem);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(value: 'resolve', child: Text(l10n.contractResolveProblem)),
                            PopupMenuItem(value: 'escalate', child: Text(l10n.contractEscalateProblem)),
                          ],
                        )
                      : null,
                );
              },
            ),
    );
  }
}

class _ProblemInput {
  const _ProblemInput({required this.category, required this.description, this.images = const []});

  final String category;
  final String description;
  final List<String> images;
}

class _ReportProblemDialog extends StatefulWidget {
  const _ReportProblemDialog();

  @override
  State<_ReportProblemDialog> createState() => _ReportProblemDialogState();
}

class _ReportProblemDialogState extends State<_ReportProblemDialog> {
  static const _categories = ['scope_disagreement', 'payment_issue', 'quality_issue', 'no_show', 'other'];

  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _imagesController = TextEditingController();
  String _category = 'scope_disagreement';

  @override
  void dispose() {
    _descriptionController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  String _categoryLabel(AppLocalizations l10n, String category) => switch (category) {
        'scope_disagreement' => l10n.contractProblemCategoryScopeDisagreement,
        'payment_issue' => l10n.contractProblemCategoryPaymentIssue,
        'quality_issue' => l10n.contractProblemCategoryQualityIssue,
        'no_show' => l10n.contractProblemCategoryNoShow,
        _ => l10n.contractProblemCategoryOther,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.contractReportProblem),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(labelText: l10n.contractProblemCategoryField),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(_categoryLabel(l10n, c)))).toList(),
                onChanged: (value) => setState(() => _category = value ?? _category),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: l10n.contractProblemDescriptionField),
                validator: (value) => (value == null || value.trim().isEmpty) ? l10n.contractDescriptionTooShort : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _imagesController,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.contractProblemImagesField),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            final images = _imagesController.text
                .split('\n')
                .map((line) => line.trim())
                .where((line) => line.isNotEmpty)
                .toList();
            Navigator.of(context).pop(
              _ProblemInput(category: _category, description: _descriptionController.text.trim(), images: images),
            );
          },
          child: Text(l10n.contractReportProblem),
        ),
      ],
    );
  }
}
