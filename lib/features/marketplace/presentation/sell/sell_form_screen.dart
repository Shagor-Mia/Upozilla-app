import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_gate.dart';
import '../../../../core/data/locations_repository.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/models/location.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/snackbars.dart';
import '../../data/marketplace_repository.dart';
import '../../domain/listing_query.dart';
import '../marketplace_providers.dart';

/// One form shared by the Local Bazar and Exchange "sell" flows, parameterized
/// by [listingType] (`product` | `exchange`). Mirrors
/// `frontend/components/listings/ListingForm.tsx`'s field set minus
/// `business_id` (Section 12: no "my businesses" endpoint exists yet to
/// populate a picker for it, and the field is nullable server-side).
///
/// Anyone can open and fill this form signed out - it's not gated on entry.
/// Submitting is what checks sign-in/phone-verification (`ensureAuthed`),
/// opening the in-place popup and resubmitting automatically once resolved,
/// instead of replacing the whole screen with a "please sign in" message.
class SellFormScreen extends StatelessWidget {
  const SellFormScreen({super.key, required this.listingType});

  /// `product` | `exchange`
  final String listingType;

  bool get _isExchange => listingType == 'exchange';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(_isExchange ? l10n.sellExchangeTitle : l10n.sellLocalBazarTitle)),
      body: _SellForm(listingType: listingType),
    );
  }
}

class _SellForm extends ConsumerStatefulWidget {
  const _SellForm({required this.listingType});

  final String listingType;

  @override
  ConsumerState<_SellForm> createState() => _SellFormState();
}

class _SellFormState extends ConsumerState<_SellForm> {
  static const _maxImages = 8;
  static const _conditions = ['new', 'used'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _imagesController = TextEditingController();

  String? _categoryId;
  String? _locationId;
  String _condition = 'used';
  bool _isNegotiable = false;
  bool _submitting = false;
  Map<String, String> _fieldErrors = const {};

  bool get _isExchange => widget.listingType == 'exchange';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imagesController.dispose();
    super.dispose();
  }

  List<String> _parseImages() =>
      _imagesController.text.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();

  void _submit() {
    setState(() => _fieldErrors = const {});
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.ensureAuthed(action: _performSubmit, requirePhoneVerified: true);
  }

  Future<void> _performSubmit() async {
    final l10n = context.l10n;
    final price = double.parse(_priceController.text.trim());
    final images = _parseImages();
    final repository = ref.read(marketplaceRepositoryProvider);

    setState(() => _submitting = true);
    try {
      final String newId;
      if (_isExchange) {
        final listing = await repository.createExchangeListing(
          categoryId: _categoryId!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          price: price,
          isNegotiable: _isNegotiable,
          condition: _condition,
          images: images,
          locationId: _locationId!,
        );
        newId = listing.id;
      } else {
        final product = await repository.createProduct(
          categoryId: _categoryId!,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          price: price,
          condition: _condition,
          images: images,
          locationId: _locationId!,
        );
        newId = product.id;
      }
      if (!mounted) return;
      showMessageSnackBar(context, l10n.listingCreated);
      context.pushReplacement(_isExchange ? AppRoutes.exchange(newId) : AppRoutes.product(newId));
    } on ValidationException catch (e) {
      // Inline-highlight fields the backend named directly, but always also
      // surface `e.message` - a nested Pydantic `loc` (e.g. `images.0`) would
      // otherwise map to no visible field and fail silently.
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
    final categoriesValue = ref.watch(listingCategoriesProvider);
    final locationsValue = ref.watch(sellLocationOptionsProvider);

    if (categoriesValue.isLoading || locationsValue.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (categoriesValue.hasError) {
      return AsyncValueWidget<List<ListingCategory>>(
        value: categoriesValue,
        onRetry: () => ref.invalidate(listingCategoriesProvider),
        data: (_) => const SizedBox.shrink(),
      );
    }
    if (locationsValue.hasError) {
      return AsyncValueWidget<List<AppLocation>>(
        value: locationsValue,
        onRetry: () => ref.invalidate(sellLocationOptionsProvider),
        data: (_) => const SizedBox.shrink(),
      );
    }

    final categories = categoriesValue.requireValue;
    final locations = locationsValue.requireValue;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: l10n.listingTitleField, errorText: _fieldErrors['title']),
              validator: (value) => (value == null || value.trim().length < 3) ? l10n.listingTitleTooShort : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration:
                  InputDecoration(labelText: l10n.listingDescriptionField, errorText: _fieldErrors['description']),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.listingPriceField, errorText: _fieldErrors['price']),
              validator: (value) {
                final parsed = double.tryParse((value ?? '').trim());
                return (parsed == null || parsed < 0) ? l10n.listingPriceInvalid : null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _categoryId,
              decoration: InputDecoration(labelText: l10n.listingCategoryField, errorText: _fieldErrors['category_id']),
              items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (value) => setState(() => _categoryId = value),
              validator: (value) => value == null ? l10n.listingCategoryRequired : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _locationId,
              decoration: InputDecoration(labelText: l10n.listingLocationField, errorText: _fieldErrors['location_id']),
              items: locations.map((loc) => DropdownMenuItem(value: loc.id, child: Text(loc.displayLabel))).toList(),
              onChanged: (value) => setState(() => _locationId = value),
              validator: (value) => value == null ? l10n.listingLocationRequired : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _condition,
              decoration: InputDecoration(labelText: l10n.condition, errorText: _fieldErrors['condition']),
              items: _conditions
                  .map((c) => DropdownMenuItem(value: c, child: Text(c == 'new' ? l10n.conditionNew : l10n.conditionUsed)))
                  .toList(),
              onChanged: (value) => setState(() => _condition = value ?? _condition),
            ),
            if (_isExchange) ...[
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.negotiable),
                value: _isNegotiable,
                onChanged: (value) => setState(() => _isNegotiable = value),
              ),
            ],
            const SizedBox(height: 16),
            TextFormField(
              controller: _imagesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.listingImagesField,
                helperText: l10n.listingImagesHint(_maxImages),
                errorText: _fieldErrors['images'],
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(l10n.submitListing),
            ),
          ],
        ),
      ),
    );
  }
}
