import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/auth/auth_controller.dart';
import '../../../../core/auth/auth_gate.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';
import '../../../../core/utils/external_links.dart';
import '../../../../core/widgets/snackbars.dart';
import '../../data/marketplace_repository.dart';
import '../../domain/contact_reveal.dart';

/// Buyer-side actions on a listing detail screen: message the seller, reveal
/// the phone number, favourite, report. Mirrors
/// `frontend/components/listings/ListingActions.tsx`'s gating: message/contact
/// require phone verification, favourite/report only require sign-in - and
/// mirrors its resume behaviour too: every button is active for a signed-out
/// visitor, tapping it opens the sign-in/verify-phone sheet in place, and the
/// exact action resumes automatically once that's resolved (`ensureAuthed`,
/// `core/auth/auth_gate.dart`). The seller viewing their own listing sees a
/// "manage it" pointer instead.
class ListingActions extends ConsumerStatefulWidget {
  const ListingActions({
    super.key,
    required this.listingType,
    required this.listingId,
    required this.sellerId,
    required this.isFavorited,
    required this.favoritesCount,
  });

  /// `exchange` | `marketplace`
  final String listingType;
  final String listingId;
  final String sellerId;
  final bool isFavorited;
  final int favoritesCount;

  @override
  ConsumerState<ListingActions> createState() => _ListingActionsState();
}

class _ListingActionsState extends ConsumerState<ListingActions> {
  late bool _favorited = widget.isFavorited;
  late int _favoritesCount = widget.favoritesCount;
  bool _favoriteBusy = false;
  bool _contactBusy = false;
  ContactReveal? _contact;
  bool _reported = false;

  MarketplaceRepository get _repository => ref.read(marketplaceRepositoryProvider);

  bool get _isExchange => widget.listingType == 'exchange';

  Future<void> _toggleFavorite() async {
    if (_favoriteBusy) return;
    final next = !_favorited;
    setState(() {
      _favorited = next;
      _favoritesCount += next ? 1 : -1;
      _favoriteBusy = true;
    });
    try {
      final result = await _repository.setFavorite(
        listingType: widget.listingType,
        listingId: widget.listingId,
        favorite: next,
      );
      if (mounted) setState(() => _favorited = result);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        _favorited = !next;
        _favoritesCount += next ? -1 : 1;
      });
      showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _favoriteBusy = false);
    }
  }

  Future<void> _revealContact() async {
    setState(() => _contactBusy = true);
    try {
      final contact = _isExchange
          ? await _repository.revealExchangeContact(widget.listingId)
          : await _repository.revealProductContact(widget.listingId);
      if (mounted) setState(() => _contact = contact);
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _contactBusy = false);
    }
  }

  void _messageSeller() {
    context.push(AppRoutes.startConversation(widget.listingType, widget.listingId));
  }

  Future<void> _submitReport(String reason, String? details) async {
    try {
      await _repository.reportListing(
        listingType: widget.listingType,
        listingId: widget.listingId,
        reason: reason,
        details: details,
      );
      if (!mounted) return;
      setState(() => _reported = true);
      showMessageSnackBar(context, context.l10n.reportSubmitted);
    } on AppException catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    }
  }

  void _openReportSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ReportSheet(onSubmit: _submitReport),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final currentUserId = ref.watch(authControllerProvider).valueOrNull?.user?.id;

    if (currentUserId != null && currentUserId == widget.sellerId) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.thisIsYourListing, style: theme.textTheme.titleSmall),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => context.push(AppRoutes.myListings),
                child: Text(l10n.manageFromMyListings),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: () => ref.ensureAuthed(action: _messageSeller, requirePhoneVerified: true),
                icon: const Icon(Icons.forum_outlined),
                label: Text(l10n.messageSeller),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _contact != null
                  ? OutlinedButton.icon(
                      onPressed: () => ExternalLinks.dial(_contact!.phone),
                      icon: const Icon(Icons.call),
                      label: Text(_contact!.phone, overflow: TextOverflow.ellipsis),
                    )
                  : OutlinedButton.icon(
                      onPressed: _contactBusy
                          ? null
                          : () => ref.ensureAuthed(action: _revealContact, requirePhoneVerified: true),
                      icon: const Icon(Icons.call_outlined),
                      label: Text(l10n.showPhoneNumber),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton.icon(
              onPressed: _favoriteBusy ? null : () => ref.ensureAuthed(action: _toggleFavorite),
              icon: Icon(_favorited ? Icons.favorite : Icons.favorite_border),
              label: Text('${_favorited ? l10n.saved : l10n.save} ($_favoritesCount)'),
            ),
            const Spacer(),
            if (_reported)
              Text(l10n.reportThanks, style: theme.textTheme.bodySmall)
            else
              TextButton.icon(
                onPressed: () => ref.ensureAuthed(action: _openReportSheet),
                icon: const Icon(Icons.flag_outlined),
                label: Text(l10n.report),
              ),
          ],
        ),
      ],
    );
  }
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet({required this.onSubmit});

  final Future<void> Function(String reason, String? details) onSubmit;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  static const _reasons = [
    'spam',
    'scam',
    'prohibited_item',
    'wrong_category',
    'offensive',
    'duplicate',
    'other',
  ];

  final _detailsController = TextEditingController();
  String _reason = _reasons.first;
  bool _submitting = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  String _reasonLabel(BuildContext context, String reason) {
    final l10n = context.l10n;
    return switch (reason) {
      'spam' => l10n.reportReasonSpam,
      'scam' => l10n.reportReasonScam,
      'prohibited_item' => l10n.reportReasonProhibitedItem,
      'wrong_category' => l10n.reportReasonWrongCategory,
      'offensive' => l10n.reportReasonOffensive,
      'duplicate' => l10n.reportReasonDuplicate,
      _ => l10n.reportReasonOther,
    };
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await widget.onSubmit(_reason, _detailsController.text.trim().isEmpty ? null : _detailsController.text.trim());
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.reportListing, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _reason,
            decoration: InputDecoration(labelText: l10n.reportReasonLabel),
            items: _reasons
                .map((r) => DropdownMenuItem(value: r, child: Text(_reasonLabel(context, r))))
                .toList(),
            onChanged: (value) => setState(() => _reason = value ?? _reason),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _detailsController,
            maxLines: 3,
            maxLength: 1000,
            decoration: InputDecoration(labelText: l10n.reportDetailsOptional),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Text(l10n.submitReport),
          ),
        ],
      ),
    );
  }
}
