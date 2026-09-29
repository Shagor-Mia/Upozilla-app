import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upazila_app/core/auth/auth_controller.dart';
import 'package:upazila_app/core/auth/auth_state.dart';
import 'package:upazila_app/core/l10n/l10n.dart';
import 'package:upazila_app/core/network/connectivity.dart';
import 'package:upazila_app/features/contracts/presentation/contract_detail_controller.dart';
import 'package:upazila_app/features/contracts/presentation/contract_detail_screen.dart';

class _FakeAuthController extends AuthController {
  @override
  Future<AuthState> build() async => const AuthState.authenticated(null);
}

/// Skips `_loadAll()`/`_connect()`/polling (real network + WebSocket) entirely
/// by overriding `build()` before it can kick any of that off.
class _FakeContractDetailController extends ContractDetailController {
  @override
  ContractDetailState build(String arg) => const ContractDetailState(loading: false);
}

Future<void> _pump(WidgetTester tester, {required bool offline}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        isOfflineProvider.overrideWith((ref) => Stream.value(offline)),
        authControllerProvider.overrideWith(_FakeAuthController.new),
        contractDetailControllerProvider.overrideWith(_FakeContractDetailController.new),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ContractDetailScreen(id: 'c1'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('ContractDetailScreen shows the offline gate instead of content when offline', (tester) async {
    await _pump(tester, offline: true);

    expect(find.byIcon(Icons.wifi_off_rounded), findsOneWidget);
  });

  testWidgets('ContractDetailScreen shows normal content once online', (tester) async {
    await _pump(tester, offline: false);

    expect(find.byIcon(Icons.wifi_off_rounded), findsNothing);
  });
}
