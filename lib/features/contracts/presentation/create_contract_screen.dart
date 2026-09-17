import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/auth_gate.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/phone.dart';
import '../../../core/widgets/snackbars.dart';
import '../data/contracts_repository.dart';
import 'contracts_providers.dart';

/// Modeled on `sell_form_screen.dart`: anyone can open this screen and start
/// filling it signed out; both the worker phone-lookup and the final submit
/// check sign-in/phone-verification (`ensureAuthed`) at the moment they're
/// used, opening the in-place popup and resuming automatically - rather than
/// replacing the whole screen with a "please sign in" message up front.
/// `_fieldErrors` from `ValidationException`, submit → snackbar → push detail.
class CreateContractScreen extends StatelessWidget {
  const CreateContractScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createContractTitle)),
      body: const _CreateContractForm(),
    );
  }
}

class _CreateContractForm extends ConsumerStatefulWidget {
  const _CreateContractForm();

  @override
  ConsumerState<_CreateContractForm> createState() => _CreateContractFormState();
}

class _CreateContractFormState extends ConsumerState<_CreateContractForm> {
  static const _maxImages = 5;
  static const _paymentTypes = ['fixed', 'hourly', 'daily', 'milestone'];

  final _formKey = GlobalKey<FormState>();
  final _workerPhoneController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _imagesController = TextEditingController();

  String _paymentType = 'fixed';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _submitting = false;
  bool _lookingUp = false;
  String? _workerId;
  String? _workerName;
  String? _workerLookupError;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _workerPhoneController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  List<String> _parseImages() =>
      _imagesController.text.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();

  void _lookupWorker() {
    ref.ensureAuthed(action: _performLookupWorker, requirePhoneVerified: true);
  }

  Future<void> _performLookupWorker() async {
    final l10n = context.l10n;
    final normalized = normalizeBdPhone(_workerPhoneController.text);
    if (normalized == null) {
      setState(() => _workerLookupError = l10n.invalidPhone);
      return;
    }
    setState(() {
      _lookingUp = true;
      _workerLookupError = null;
      _workerId = null;
      _workerName = null;
    });
    try {
      final worker = await ref.read(contractsRepositoryProvider).lookupWorkerByPhone(normalized);
      if (!mounted) return;
      if (worker == null) {
        setState(() => _workerLookupError = l10n.workerNotFound);
      } else {
        setState(() {
          _workerId = worker.id;
          _workerName = worker.fullName;
        });
      }
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _lookingUp = false);
    }
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initial = (isStart ? _startDate : _endDate) ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

  void _submit() {
    setState(() => _fieldErrors = const {});
    final workerId = _workerId;
    if (workerId == null) {
      setState(() => _workerLookupError = context.l10n.workerNotFound);
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.ensureAuthed(action: _performSubmit, requirePhoneVerified: true);
  }

  Future<void> _performSubmit() async {
    final workerId = _workerId!;
    final l10n = context.l10n;
    final amount = double.parse(_amountController.text.trim());

    setState(() => _submitting = true);
    try {
      final contract = await ref.read(contractsRepositoryProvider).createContract(
            workerUserId: workerId,
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            paymentAmount: amount,
            paymentType: _paymentType,
            startDate: _startDate,
            endDate: _endDate,
            referenceImages: _parseImages(),
          );
      if (!mounted) return;
      ref.invalidate(myContractsProvider);
      showMessageSnackBar(context, l10n.contractCreated);
      context.pushReplacement(AppRoutes.contract(contract.id));
    } on ValidationException catch (e) {
      setState(() => _fieldErrors = e.fieldErrors);
      _formKey.currentState?.validate();
      if (mounted) showErrorSnackBar(context, e);
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _workerPhoneController,
                    keyboardType: TextInputType.phone,
                    enabled: _workerId == null,
                    decoration: InputDecoration(
                      labelText: l10n.contractWorkerPhoneField,
                      hintText: l10n.phoneHint,
                      errorText: _workerLookupError,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _workerId != null
                      ? IconButton(
                          tooltip: l10n.cancel,
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() {
                            _workerId = null;
                            _workerName = null;
                            _workerPhoneController.clear();
                          }),
                        )
                      : FilledButton(
                          onPressed: _lookingUp ? null : _lookupWorker,
                          child: _lookingUp
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(l10n.findWorkerByPhone),
                        ),
                ),
              ],
            ),
            if (_workerName != null) ...[
              const SizedBox(height: 4),
              Text(l10n.contractWorkerFound(_workerName!), style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.contractTitleField, errorText: _fieldErrors['title']),
              validator: (value) => (value == null || value.trim().length < 3) ? l10n.contractTitleTooShort : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration:
                  InputDecoration(labelText: l10n.contractDescriptionField, errorText: _fieldErrors['description']),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? l10n.contractDescriptionTooShort : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.contractPaymentAmountField,
                errorText: _fieldErrors['payment_amount'],
              ),
              validator: (value) {
                final parsed = double.tryParse((value ?? '').trim());
                return (parsed == null || parsed <= 0) ? l10n.contractPaymentAmountInvalid : null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _paymentType,
              decoration: InputDecoration(
                labelText: l10n.contractPaymentTypeField,
                errorText: _fieldErrors['payment_type'],
              ),
              items: _paymentTypes
                  .map((type) => DropdownMenuItem(value: type, child: Text(_paymentTypeLabel(l10n, type))))
                  .toList(),
              onChanged: (value) => setState(() => _paymentType = value ?? _paymentType),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(isStart: true),
                    child: Text(_startDate == null ? l10n.contractStartDateField : Formatters.date(_startDate!)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickDate(isStart: false),
                    child: Text(_endDate == null ? l10n.contractEndDateField : Formatters.date(_endDate!)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imagesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.contractReferenceImagesField,
                helperText: l10n.listingImagesHint(_maxImages),
                errorText: _fieldErrors['reference_images'],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.createContractSubmit),
            ),
          ],
        ),
      ),
    );
  }

  String _paymentTypeLabel(AppLocalizations l10n, String type) => switch (type) {
        'hourly' => l10n.contractPaymentTypeHourly,
        'daily' => l10n.contractPaymentTypeDaily,
        'milestone' => l10n.contractPaymentTypeMilestone,
        _ => l10n.contractPaymentTypeFixed,
      };
}
