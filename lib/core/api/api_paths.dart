/// Backend route paths relative to the `/api/v1` base URL. Keeping them in one
/// place makes a backend contract change a single-file edit on the app side.
class ApiPaths {
  const ApiPaths._();

  static const meta = '/meta';

  static const authOtpRequest = '/auth/otp/request';
  static const authOtpVerify = '/auth/otp/verify';
  static const authLogin = '/auth/login';
  static const authRefresh = '/auth/refresh';
  static const authLogout = '/auth/logout';
  static const authMe = '/auth/me';
  static const authWsTicket = '/auth/ws-ticket';

  static const locations = '/locations';

  static const places = '/places';
  static String place(String slug) => '/places/$slug';

  static const hospitals = '/hospitals';
  static String hospital(String id) => '/hospitals/$id';
  static String hospitalDoctors(String id) => '/hospitals/$id/doctors';

  static const markets = '/markets';
  static String market(String id) => '/markets/$id';

  static const businesses = '/businesses';
  static String business(String slug) => '/businesses/$slug';

  static const shops = '/shops';
  static String shop(String id) => '/shops/$id';
  static const shopsMine = '/shops/mine';
  static const shopCategories = '/shops/categories';

  static const representatives = '/representatives';
  static String representative(String id) => '/representatives/$id';
  static const representativesMine = '/representatives/mine';

  static const news = '/news';
  static String newsArticle(String slug) => '/news/$slug';

  static const services = '/services';
  static const serviceCategories = '/services/categories';
  static String service(String id) => '/services/$id';

  static const marketplaceProducts = '/marketplace/products';
  static String marketplaceProduct(String id) => '/marketplace/products/$id';
  static const marketplaceProductsMine = '/marketplace/products/mine';
  static String marketplaceProductContact(String id) => '/marketplace/products/$id/contact';
  static const marketplaceCategories = '/marketplace/categories';

  static const exchangeListings = '/exchange/listings';
  static String exchangeListing(String id) => '/exchange/listings/$id';
  static const exchangeListingsMine = '/exchange/listings/mine';
  static String exchangeListingContact(String id) => '/exchange/listings/$id/contact';

  static const exchangeFavorites = '/exchange/favorites';
  static String exchangeFavorite(String listingType, String listingId) =>
      '/exchange/favorites/$listingType/$listingId';
  static String exchangeReport(String listingType, String listingId) =>
      '/exchange/reports/$listingType/$listingId';

  static String seller(String id) => '/sellers/$id';
  static String sellerReviews(String id) => '/sellers/$id/reviews';

  static const conversations = '/conversations';
  static String conversation(String id) => '/conversations/$id';
  static String conversationMessages(String id) => '/conversations/$id/messages';

  // Section 17 Phase 4 AI layer.
  static const faqs = '/faqs';
  static const aiChat = '/ai/chat';
  static const recommendations = '/recommendations';

  // Work Contracts module.
  static const contracts = '/contracts';
  static String contract(String id) => '/contracts/$id';
  static const contractsMine = '/contracts/mine';
  static String contractAccept(String id) => '/contracts/$id/accept';
  static String contractReject(String id) => '/contracts/$id/reject';
  static String contractCancel(String id) => '/contracts/$id/cancel';
  static String contractComplete(String id) => '/contracts/$id/complete';
  static String contractProgress(String id) => '/contracts/$id/progress';
  static String contractPayments(String id) => '/contracts/$id/payments';
  static String contractProblems(String id) => '/contracts/$id/problems';
  static String contractPaymentConfirm(String id, String pid) => '/contracts/$id/payments/$pid/confirm';
  static String contractProblemResolve(String id, String pid) => '/contracts/$id/problems/$pid/resolve';
  static String contractProblemEscalate(String id, String pid) => '/contracts/$id/problems/$pid/escalate';
  static const userLookup = '/users/lookup';
}
