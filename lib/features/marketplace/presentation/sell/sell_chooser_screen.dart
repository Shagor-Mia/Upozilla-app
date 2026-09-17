import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/routing/app_routes.dart';

/// Mirrors the web's two `/sell/*` entry points: Local Bazar (business/B2C
/// listing) vs. Exchange (C2C classifieds).
class SellChooserScreen extends StatelessWidget {
  const SellChooserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.sellSomething)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SellOptionCard(
            icon: Icons.storefront_outlined,
            title: l10n.localBazar,
            body: l10n.sellLocalBazarDescription,
            onTap: () => context.push(AppRoutes.sellProduct),
          ),
          const SizedBox(height: 16),
          _SellOptionCard(
            icon: Icons.swap_horiz_rounded,
            title: l10n.exchange,
            body: l10n.sellExchangeDescription,
            onTap: () => context.push(AppRoutes.sellExchange),
          ),
          const SizedBox(height: 16),
          _SellOptionCard(
            icon: Icons.storefront,
            title: l10n.sellShopTitle,
            body: l10n.sellShopDescription,
            onTap: () => context.push(AppRoutes.sellShop),
          ),
        ],
      ),
    );
  }
}

class _SellOptionCard extends StatelessWidget {
  const _SellOptionCard({required this.icon, required this.title, required this.body, required this.onTap});

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(icon, size: 36, color: theme.colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(body, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outline)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
