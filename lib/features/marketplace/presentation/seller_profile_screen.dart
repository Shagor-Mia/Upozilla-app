import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/auth_controller.dart';
import '../../../core/auth/auth_gate.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/l10n/l10n.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/snackbars.dart';
import '../data/marketplace_repository.dart';
import '../domain/seller_review.dart';
import 'marketplace_providers.dart';
import 'widgets/seller_card.dart';

/// `GET /sellers/{id}` header + reviews, plus (when signed in, phone-verified
/// and not viewing your own profile) a review submission form. Mirrors
/// `frontend/components/sellers/ReviewForm.tsx`.
class SellerProfileScreen extends ConsumerWidget {
  const SellerProfileScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(sellerProfileProvider(id));
    final auth = ref.watch(authControllerProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellerProfileTitle)),
      body: AsyncValueWidget<SellerProfile>(
        value: value,
        onRetry: () => ref.invalidate(sellerProfileProvider(id)),
        data: (profile) {
          // Anyone but the seller themselves can review - a signed-out or
          // unverified visitor sees the form too; submitting is what checks
          // sign-in/phone-verification in place (`ensureAuthed`), instead of
          // hiding the form with no explanation.
          final canReview = auth?.user?.id != profile.summary.id;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SellerCard(seller: profile.summary),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatTile(label: l10n.activeListings, value: '${profile.activeListings}')),
                  Expanded(child: _StatTile(label: l10n.totalListings, value: '${profile.totalListings}')),
                ],
              ),
              const SizedBox(height: 24),
              Text(l10n.reviews, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (canReview) ...[
                _ReviewForm(sellerId: id, onSubmitted: () => ref.invalidate(sellerProfileProvider(id))),
                const SizedBox(height: 16),
              ],
              if (profile.reviews.isEmpty)
                EmptyState(icon: Icons.rate_review_outlined, title: l10n.noReviewsYet)
              else
                ...profile.reviews.map((review) => _ReviewTile(review: review)),
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.headlineSmall),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review});

  final SellerReview review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(review.reviewerName, style: theme.textTheme.titleSmall),
                const Spacer(),
                Text('★' * review.rating, style: TextStyle(color: theme.colorScheme.tertiary)),
              ],
            ),
            if (review.comment != null && review.comment!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(review.comment!),
            ],
            if (review.createdAt != null) ...[
              const SizedBox(height: 4),
              Text(Formatters.date(review.createdAt!, locale: locale), style: theme.textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewForm extends ConsumerStatefulWidget {
  const _ReviewForm({required this.sellerId, required this.onSubmitted});

  final String sellerId;
  final VoidCallback onSubmitted;

  @override
  ConsumerState<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends ConsumerState<_ReviewForm> {
  final _commentController = TextEditingController();
  int _rating = 5;
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    ref.ensureAuthed(action: _performSubmit, requirePhoneVerified: true);
  }

  Future<void> _performSubmit() async {
    setState(() => _submitting = true);
    try {
      await ref.read(marketplaceRepositoryProvider).submitSellerReview(
            sellerId: widget.sellerId,
            rating: _rating,
            comment: _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
          );
      if (!mounted) return;
      _commentController.clear();
      showMessageSnackBar(context, context.l10n.reviewSubmitted);
      widget.onSubmitted();
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.writeAReview, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                final starValue = index + 1;
                return IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(starValue <= _rating ? Icons.star : Icons.star_border, color: Theme.of(context).colorScheme.tertiary),
                  onPressed: () => setState(() => _rating = starValue),
                );
              }),
            ),
            TextField(
              controller: _commentController,
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.commentOptional),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(l10n.submitReview),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
