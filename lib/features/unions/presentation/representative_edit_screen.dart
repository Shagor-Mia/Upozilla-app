import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/snackbars.dart';
import '../data/representatives_repository.dart';
import '../domain/representative.dart';
import 'unions_providers.dart';
import 'widgets/representative_tile.dart';

/// Self-service bio/photo edit. Not present on the web app (no reference UX) -
/// only `bio`/`photo_url` are editable here; `location_id`/`position`/`status`
/// need CONTENT_MANAGE and are not shown (`backend/app/modules/representatives/service.py:update`).
class RepresentativeEditScreen extends ConsumerWidget {
  const RepresentativeEditScreen({super.key, required this.representativeId, this.initialRepresentative});

  final String representativeId;
  final Representative? initialRepresentative;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final initial = initialRepresentative;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.myRepresentativeProfile)),
      body: initial != null
          ? _EditForm(representative: initial)
          : AsyncValueWidget<Representative>(
              value: ref.watch(representativeDetailProvider(representativeId)),
              onRetry: () => ref.invalidate(representativeDetailProvider(representativeId)),
              data: (representative) => _EditForm(representative: representative),
            ),
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({required this.representative});

  final Representative representative;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  late final _bioController = TextEditingController(text: widget.representative.bio ?? '');
  late final _photoUrlController = TextEditingController(text: widget.representative.photoUrl ?? '');
  bool _submitting = false;

  @override
  void dispose() {
    _bioController.dispose();
    _photoUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    setState(() => _submitting = true);
    try {
      await ref.read(representativesRepositoryProvider).update(
            widget.representative.id,
            bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
            photoUrl: _photoUrlController.text.trim().isEmpty ? null : _photoUrlController.text.trim(),
          );
      ref.invalidate(myRepresentativeProvider);
      ref.invalidate(representativeDetailProvider(widget.representative.id));
      if (!mounted) return;
      showMessageSnackBar(context, l10n.profileUpdated);
      Navigator.of(context).pop();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            RepresentativeTile.positionLabel(l10n, widget.representative.position),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(widget.representative.locationName, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 24),
          TextField(
            controller: _bioController,
            maxLines: 5,
            decoration: InputDecoration(labelText: l10n.representativeBioField),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _photoUrlController,
            decoration: InputDecoration(labelText: l10n.representativePhotoField),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
