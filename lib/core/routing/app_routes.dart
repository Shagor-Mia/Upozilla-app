/// Route paths. Detail paths mirror the web URLs so Android App Links / iOS
/// Universal Links can open the same content the web serves (Section 9).
class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const explore = '/explore';
  static const marketplace = '/marketplace';
  static const news = '/news';
  static const profile = '/profile';
  static const notifications = '/notifications';

  static const login = '/auth/login';
  static const otp = '/auth/otp';
  static const passwordLogin = '/auth/password';

  static const placePattern = '/places/:slug';
  static const hospitalPattern = '/hospitals/:id';
  static const businessPattern = '/business/:slug';
  static const newsPattern = '/news/:slug';
  static const productPattern = '/marketplace/:id';
  static const exchangePattern = '/exchange/:id';
  static const servicePattern = '/services/:id';
  static const servicesList = '/services';
  static const marketPattern = '/markets/:id';
  static const shopPattern = '/shops/:id';

  static String place(String slug) => '/places/$slug';
  static String hospital(String id) => '/hospitals/$id';
  static String business(String slug) => '/business/$slug';
  static String newsArticle(String slug) => '/news/$slug';
  static String product(String id) => '/marketplace/$id';
  static String exchange(String id) => '/exchange/$id';
  static String service(String id) => '/services/$id';
  static String market(String id) => '/markets/$id';
  static String shop(String id) => '/shops/$id';

  // Messaging.
  static const conversations = '/messages';
  static const conversationPattern = '/messages/:id';
  static const startConversationPattern = '/messages/start/:type/:id';

  static String conversation(String id) => '/messages/$id';
  static String startConversation(String listingType, String listingId) => '/messages/start/$listingType/$listingId';

  // Sell / manage listings.
  static const sell = '/sell';
  static const sellProduct = '/sell/product';
  static const sellExchange = '/sell/exchange';
  static const sellShop = '/sell/shop';
  static const myListings = '/account/listings';
  static const myShops = '/account/shops';
  static const favorites = '/account/favorites';

  // Unions / villages / representatives.
  static const unions = '/unions';
  static const unionPattern = '/unions/:id';
  static const villagePattern = '/unions/:id/villages/:villageId';
  static const representativeEditPattern = '/representatives/:id/edit';

  static String union(String id) => '/unions/$id';
  static String village(String unionId, String villageId) => '/unions/$unionId/villages/$villageId';
  static String representativeEdit(String id) => '/representatives/$id/edit';

  // Sellers.
  static const sellerPattern = '/sellers/:id';

  static String seller(String id) => '/sellers/$id';

  // Section 17 Phase 4 AI layer.
  static const faqs = '/faqs';
  static const askAi = '/ask';

  // Work Contracts module.
  static const contracts = '/contracts';
  static const createContract = '/contracts/create';
  static const contractPattern = '/contracts/:id';

  static String contract(String id) => '/contracts/$id';
}
