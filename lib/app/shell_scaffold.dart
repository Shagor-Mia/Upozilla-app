import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/l10n.dart';
import '../core/widgets/offline_banner.dart';

/// Bottom-navigation shell around the five stateful branches.
class ShellScaffold extends StatelessWidget {
  const ShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onDestinationSelected(int index) {
    // Tapping the active tab pops that branch back to its root.
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l10n.navHome),
          NavigationDestination(icon: const Icon(Icons.explore_outlined), selectedIcon: const Icon(Icons.explore), label: l10n.navExplore),
          NavigationDestination(icon: const Icon(Icons.storefront_outlined), selectedIcon: const Icon(Icons.storefront), label: l10n.navMarketplace),
          NavigationDestination(icon: const Icon(Icons.newspaper_outlined), selectedIcon: const Icon(Icons.newspaper), label: l10n.navNews),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l10n.navProfile),
        ],
      ),
    );
  }
}
