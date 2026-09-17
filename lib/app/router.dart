import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/auth_controller.dart';
import '../core/auth/otp_args.dart';
import '../core/models/location.dart';
import '../core/routing/app_routes.dart';
import '../features/ai_chat/presentation/ai_chat_screen.dart';
import '../features/auth/presentation/otp_verify_screen.dart';
import '../features/auth/presentation/password_login_screen.dart';
import '../features/auth/presentation/phone_login_screen.dart';
import '../features/contracts/presentation/contract_detail_screen.dart';
import '../features/contracts/presentation/create_contract_screen.dart';
import '../features/contracts/presentation/my_contracts_screen.dart';
import '../features/explore/presentation/business_detail_screen.dart';
import '../features/explore/presentation/explore_providers.dart';
import '../features/explore/presentation/explore_screen.dart';
import '../features/explore/presentation/hospital_detail_screen.dart';
import '../features/explore/presentation/place_detail_screen.dart';
import '../features/faqs/presentation/faq_list_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/marketplace/presentation/exchange_detail_screen.dart';
import '../features/marketplace/presentation/favorites_screen.dart';
import '../features/marketplace/presentation/marketplace_screen.dart';
import '../features/marketplace/presentation/my_listings_screen.dart';
import '../features/marketplace/presentation/product_detail_screen.dart';
import '../features/marketplace/presentation/sell/sell_chooser_screen.dart';
import '../features/marketplace/presentation/sell/sell_form_screen.dart';
import '../features/marketplace/presentation/seller_profile_screen.dart';
import '../features/messaging/presentation/chat_screen.dart';
import '../features/messaging/presentation/conversations_list_screen.dart';
import '../features/messaging/presentation/start_conversation_screen.dart';
import '../features/news/presentation/news_detail_screen.dart';
import '../features/news/presentation/news_list_screen.dart';
import '../features/notifications/presentation/notifications_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/services/presentation/service_detail_screen.dart';
import '../features/services/presentation/services_list_screen.dart';
import '../features/shops/presentation/market_detail_screen.dart';
import '../features/shops/presentation/my_shops_screen.dart';
import '../features/shops/presentation/sell/sell_shop_screen.dart';
import '../features/shops/presentation/shop_detail_screen.dart';
import '../features/unions/domain/representative.dart';
import '../features/unions/presentation/representative_edit_screen.dart';
import '../features/unions/presentation/union_detail_screen.dart';
import '../features/unions/presentation/unions_list_screen.dart';
import '../features/unions/presentation/village_detail_screen.dart';
import 'shell_scaffold.dart';

/// Bridges Riverpod auth changes into go_router's `refreshListenable`.
class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

/// The AI chat bubble and the auth-prompt sheet are both mounted in
/// `app.dart`'s `MaterialApp.builder`, outside the router's own `Navigator` -
/// this key is how they reach a real `Overlay`/`Navigator` context to show a
/// bottom sheet (`showModalBottomSheet` needs one; a plain `context` from
/// that builder doesn't have it).
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// The app is the only layer allowed to import from several features at
/// once — it composes them. Features avoid importing each other's
/// *presentation* layers; reading a sibling's stable domain model/repository
/// is accepted when a screen is a natural sub-view of that other feature
/// (e.g. `shops` showing its parent `Market`, `unions` showing a village's
/// `Place`s, `profile` linking to the caller's own representative record) —
/// see `shops_providers.dart`, `unions_providers.dart`, `profile_screen.dart`.
final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier();
  ref.onDispose(refreshNotifier.dispose);
  ref.listen(authControllerProvider, (_, __) => refreshNotifier.refresh());

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: refreshNotifier,
    debugLogDiagnostics: kDebugMode,
    redirect: (context, state) {
      final signedIn = ref.read(isAuthenticatedProvider);
      // `/auth/otp` is excluded: the profile feature's verify-phone flow
      // reuses this same screen while already signed in (`purpose:
      // verify_phone`), and it must not get bounced back to /profile before
      // it can even show. It stays safe unauthenticated too - the route's own
      // `redirect` already requires in-memory `OtpArgs`.
      final onAuthScreen = state.matchedLocation.startsWith('/auth') && state.matchedLocation != AppRoutes.otp;
      if (signedIn && onAuthScreen) return AppRoutes.profile;
      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => ShellScaffold(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                builder: (_, state) => ExploreScreen(
                  initialTab: ExploreTab.fromName(state.uri.queryParameters['tab']),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.marketplace, builder: (_, __) => const MarketplaceScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.news, builder: (_, __) => const NewsListScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen())],
          ),
        ],
      ),

      // Auth (pushed above the shell).
      GoRoute(path: AppRoutes.login, builder: (_, __) => const PhoneLoginScreen()),
      GoRoute(path: AppRoutes.passwordLogin, builder: (_, __) => const PasswordLoginScreen()),
      GoRoute(
        path: AppRoutes.otp,
        // The OTP screen is only reachable with in-memory args; a cold deep
        // link or restore lands on the phone screen instead.
        redirect: (_, state) => state.extra is OtpArgs ? null : AppRoutes.login,
        builder: (_, state) => OtpVerifyScreen(args: state.extra as OtpArgs),
      ),

      // Detail routes mirror web URLs for App Links / Universal Links.
      GoRoute(
        path: AppRoutes.placePattern,
        builder: (_, state) => PlaceDetailScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: AppRoutes.hospitalPattern,
        builder: (_, state) => HospitalDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.businessPattern,
        builder: (_, state) => BusinessDetailScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: AppRoutes.newsPattern,
        builder: (_, state) => NewsDetailScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: AppRoutes.productPattern,
        builder: (_, state) => ProductDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.exchangePattern,
        builder: (_, state) => ExchangeDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.servicesList, builder: (_, __) => const ServicesListScreen()),
      GoRoute(
        path: AppRoutes.servicePattern,
        builder: (_, state) => ServiceDetailScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),
      GoRoute(
        path: AppRoutes.marketPattern,
        builder: (_, state) => MarketDetailScreen(marketId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.shopPattern,
        builder: (_, state) => ShopDetailScreen(shopId: state.pathParameters['id']!),
      ),

      // Unions / villages / representatives.
      GoRoute(path: AppRoutes.unions, builder: (_, __) => const UnionsListScreen()),
      GoRoute(
        path: AppRoutes.unionPattern,
        builder: (_, state) => UnionDetailScreen(
          unionId: state.pathParameters['id']!,
          initialUnion: state.extra is AppLocation ? state.extra as AppLocation : null,
        ),
      ),
      GoRoute(
        path: AppRoutes.villagePattern,
        builder: (_, state) => VillageDetailScreen(
          unionId: state.pathParameters['id']!,
          villageId: state.pathParameters['villageId']!,
          initialVillage: state.extra is AppLocation ? state.extra as AppLocation : null,
        ),
      ),
      GoRoute(
        path: AppRoutes.representativeEditPattern,
        builder: (_, state) => RepresentativeEditScreen(
          representativeId: state.pathParameters['id']!,
          initialRepresentative: state.extra is Representative ? state.extra as Representative : null,
        ),
      ),

      // Section 17 Phase 4 AI layer.
      GoRoute(path: AppRoutes.faqs, builder: (_, __) => const FaqListScreen()),
      GoRoute(path: AppRoutes.askAi, builder: (_, __) => const AiChatScreen()),

      // Messaging (Section 10).
      GoRoute(path: AppRoutes.conversations, builder: (_, __) => const ConversationsListScreen()),
      GoRoute(
        path: AppRoutes.conversationPattern,
        builder: (_, state) => ChatScreen(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.startConversationPattern,
        builder: (_, state) => StartConversationScreen(
          listingType: state.pathParameters['type']!,
          listingId: state.pathParameters['id']!,
        ),
      ),

      // Sell / manage own listings.
      GoRoute(path: AppRoutes.sell, builder: (_, __) => const SellChooserScreen()),
      GoRoute(path: AppRoutes.sellProduct, builder: (_, __) => const SellFormScreen(listingType: 'product')),
      GoRoute(path: AppRoutes.sellExchange, builder: (_, __) => const SellFormScreen(listingType: 'exchange')),
      GoRoute(path: AppRoutes.sellShop, builder: (_, __) => const SellShopScreen()),
      GoRoute(path: AppRoutes.myListings, builder: (_, __) => const MyListingsScreen()),
      GoRoute(path: AppRoutes.myShops, builder: (_, __) => const MyShopsScreen()),
      GoRoute(path: AppRoutes.favorites, builder: (_, __) => const FavoritesScreen()),

      // Sellers.
      GoRoute(
        path: AppRoutes.sellerPattern,
        builder: (_, state) => SellerProfileScreen(id: state.pathParameters['id']!),
      ),

      // Work Contracts module. `createContract` is registered before the
      // `:id` pattern so the literal `/contracts/create` segment is matched
      // first.
      GoRoute(path: AppRoutes.contracts, builder: (_, __) => const MyContractsScreen()),
      GoRoute(path: AppRoutes.createContract, builder: (_, __) => const CreateContractScreen()),
      GoRoute(
        path: AppRoutes.contractPattern,
        builder: (_, state) => ContractDetailScreen(id: state.pathParameters['id']!),
      ),
    ],
  );
});
