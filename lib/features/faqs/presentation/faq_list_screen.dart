import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../domain/faq.dart';
import 'faq_providers.dart';

class FaqListScreen extends ConsumerWidget {
  const FaqListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final value = ref.watch(faqsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.faqsTitle)),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(faqsProvider.future).then((_) {}, onError: (_) {}),
        child: AsyncValueWidget<List<Faq>>(
          value: value,
          onRetry: () => ref.invalidate(faqsProvider),
          data: (faqs) {
            if (faqs.isEmpty) {
              return ListView(
                children: [const SizedBox(height: 120), EmptyState(title: l10n.faqsEmpty)],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: faqs.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, index) {
                final faq = faqs[index];
                return ExpansionTile(
                  title: Text(faq.question),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  expandedAlignment: AlignmentDirectional.centerStart,
                  children: [Text(faq.answer, textAlign: TextAlign.start)],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
