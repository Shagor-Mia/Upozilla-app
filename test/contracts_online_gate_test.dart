import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upazila_app/core/auth/auth_controller.dart';
import 'package:upazila_app/core/auth/auth_state.dart';
import 'package:upazila_app/core/l10n/l10n.dart';
import 'package:upazila_app/core/network/connectivity.dart';
import 'package:upazila_app/features/contracts/presentation/contracts_providers.dart';
import 'package:upazila_app/features/contracts/presentation/my_contracts_screen.dart';

/// Bypasses session restore/network entirely so the screen just sees a
/// signed-in-but-no-profile-yet user, matching `AuthState.authenticated(null)`.
class _FakeAuthController extends AuthController {
  @override
  Future<AuthState> build() async => const AuthState.authenticated(null);
}

Future<void> _pump(WidgetTester tester, {required bool offline}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isOfflineProvider.overrideWith((ref) => Stream.value(offline)),
        authControllerProvider.overrideWith(_FakeAuthController.new),
        myContractsProvider.overrideWith((ref, role) async => const []),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MyContractsScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('MyContractsScreen shows the offline gate instead of the list when offline', (tester) async {
    await _pump(tester, offline: true);

    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
    expect(find.byType(ChoiceChip), findsNothing);
  });

  testWidgets('MyContractsScreen shows the normal list once online', (tester) async {
    await _pump(tester, offline: false);

    expect(find.byIcon(Icons.wifi_off_rounded), findsNothing);
    expect(find.byType(ChoiceChip), findsNWidgets(3));
  });
}
