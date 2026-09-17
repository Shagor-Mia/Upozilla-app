import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_gate.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/widgets/async_value_widget.dart';
import '../../../../core/widgets/snackbars.dart';
import '../../../explore/domain/market.dart';
import '../../data/shops_repository.dart';
import '../../domain/shop.dart';
import '../shops_providers.dart';

/// Shop submission form, and `frontend/components/shops/ShopForm.tsx`'s field
/// set. Anyone can open and fill this signed out; submitting is what checks
/// sign-in/phone-verification (`ensureAuthed`) - see `SellFormScreen`, which
/// this mirrors.
class SellShopScreen extends StatelessWidget {
  const SellShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellShopTitle)),
      body: const _SellShopForm(),
    );
  }
}

class _SellShopForm extends ConsumerStatefulWidget {
  const _SellShopForm();

  @override
  ConsumerState<_SellShopForm> createState() => _SellShopFormState();
}

class _SellShopFormState extends ConsumerState<_SellShopForm> {
  static const _maxImages = 8;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _imagesController = TextEditingController();

  String? _marketId;
  String? _categoryId;
  bool _submitting = false;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _contactPhoneController.dispose();
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

    setState(() => _submitting = true);
    try {
      await ref.read(shopsRepositoryProvider).createShop(
            marketId: _marketId!,
            categoryId: _categoryId!,
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
            contactPhone: _contactPhoneController.text.trim().isEmpty ? null : _contactPhoneController.text.trim(),
            images: _parseImages(),
          );
      if (!mounted) return;
      ref.invalidate(myShopsProvider);
      showMessageSnackBar(context, l10n.shopCreated);
      context.pushReplacement(AppRoutes.myShops);
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
    final marketsValue = ref.watch(marketOptionsProvider);
    final categoriesValue = ref.watch(shopCategoriesProvider);

    if (marketsValue.isLoading || categoriesValue.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (marketsValue.hasError) {
      return AsyncValueWidget<List<Market>>(
        value: marketsValue,
        onRetry: () => ref.invalidate(marketOptionsProvider),
        data: (_) => const SizedBox.shrink(),
      );
    }
    if (categoriesValue.hasError) {
      return AsyncValueWidget<List<ShopCategory>>(
        value: categoriesValue,
        onRetry: () => ref.invalidate(shopCategoriesProvider),
        data: (_) => const SizedBox.shrink(),
      );
    }

    final markets = marketsValue.requireValue;
    final categories = categoriesValue.requireValue;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.shopNameField, errorText: _fieldErrors['name']),
              validator: (value) => (value == null || value.trim().length < 2) ? l10n.shopNameTooShort : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _marketId,
              decoration: InputDecoration(labelText: l10n.shopMarketField, errorText: _fieldErrors['market_id']),
              items: markets.map((m) => DropdownMenuItem(value: m.id, child: Text(m.name))).toList(),
              onChanged: (value) => setState(() => _marketId = value),
              validator: (value) => value == null ? l10n.shopMarketRequired : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _categoryId,
              decoration: InputDecoration(labelText: l10n.shopCategoryField, errorText: _fieldErrors['category_id']),
              items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
              onChanged: (value) => setState(() => _categoryId = value),
              validator: (value) => value == null ? l10n.shopCategoryRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactPhoneController,
              keyboardType: TextInputType.phone,
              decoration:
                  InputDecoration(labelText: l10n.shopContactPhoneField, errorText: _fieldErrors['contact_phone']),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration:
                  InputDecoration(labelText: l10n.shopDescriptionField, errorText: _fieldErrors['description']),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imagesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.shopImagesField,
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
