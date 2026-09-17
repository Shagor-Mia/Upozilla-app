import 'package:drift/drift.dart';

/// Drift schema for offline-first content sync. Mirrors the read-only
/// directory content that the app must be able to browse with zero network
/// (Places/Hospitals/Doctors/Markets/Businesses, Shops, Representatives,
/// News, Services, Locations, Faqs). Marketplace/exchange, messaging and AI
/// chat are intentionally NOT synced here — they stay online-only.
///
/// List columns (e.g. `images`, `gallery`) have no native Drift type, so they
/// are stored as JSON-encoded text and decoded in the repository mapping
/// layer, mirroring the lenient `readStringList` convention used by the
/// existing `fromJson` constructors (see core/models/json_helpers.dart).
/// `distance_km` is deliberately not stored: it is derived per-query from
/// the device's current position, not synced content.
class Places extends Table {
  TextColumn get id => text()();
  TextColumn get locationId => text()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  TextColumn get coverImage => text().nullable()();
  TextColumn get galleryJson => text().withDefault(const Constant('[]'))();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  BoolColumn get isFeatured => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('published'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Hospitals extends Table {
  TextColumn get id => text()();
  TextColumn get locationId => text()();
  TextColumn get name => text()();
  TextColumn get type => text().withDefault(const Constant('govt'))();
  TextColumn get address => text().nullable()();
  TextColumn get contact => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Doctors extends Table {
  TextColumn get id => text()();
  TextColumn get hospitalId => text()();
  TextColumn get name => text()();
  TextColumn get specialty => text().nullable()();
  TextColumn get chamberDaysJson => text().withDefault(const Constant('[]'))();
  TextColumn get chamberHours => text().nullable()();
  TextColumn get contact => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Markets extends Table {
  TextColumn get id => text()();
  TextColumn get locationId => text()();
  TextColumn get name => text()();
  TextColumn get marketDaysJson => text().withDefault(const Constant('[]'))();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get type => text().withDefault(const Constant('general'))();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Businesses extends Table {
  TextColumn get id => text()();
  TextColumn get locationId => text()();
  TextColumn get ownerUserId => text()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  TextColumn get logo => text().nullable()();
  TextColumn get coverImage => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  BoolColumn get isVerified => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}

class Shops extends Table {
  TextColumn get id => text()();
  TextColumn get marketId => text()();
  TextColumn get marketName => text()();
  TextColumn get categoryId => text()();
  TextColumn get categoryName => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get contactPhone => text().nullable()();
  TextColumn get imagesJson => text().withDefault(const Constant('[]'))();
  BoolColumn get isFeatured => boolean().withDefault(const Constant(false))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get moderationStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  TextColumn get sellerId => text()();
  TextColumn get sellerFullName => text()();
  BoolColumn get sellerPhoneVerified => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class ShopCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get slug => text()();
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Representatives extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get fullName => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get locationId => text()();
  TextColumn get locationName => text()();
  TextColumn get position => text().withDefault(const Constant('ward_member'))();
  TextColumn get bio => text().nullable()();
  TextColumn get photoUrl => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))();

  @override
  Set<Column> get primaryKey => {id};
}

class NewsArticles extends Table {
  TextColumn get id => text()();
  TextColumn get sourceId => text()();
  TextColumn get locationId => text().nullable()();
  TextColumn get category => text().nullable()();
  TextColumn get title => text()();
  TextColumn get slug => text()();
  TextColumn get summary => text().nullable()();
  TextColumn get image => text().nullable()();
  DateTimeColumn get publishedAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('published'))();
  TextColumn get body => text().nullable()();
  TextColumn get originalUrl => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Services extends Table {
  TextColumn get id => text()();
  TextColumn get locationId => text()();
  TextColumn get categoryId => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get eligibility => text().nullable()();
  TextColumn get requiredDocumentsJson => text().withDefault(const Constant('[]'))();
  RealColumn get fee => real().nullable()();
  TextColumn get officialLink => text().nullable()();
  TextColumn get officeName => text().nullable()();
  TextColumn get officeContact => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('published'))();

  @override
  Set<Column> get primaryKey => {id};
}

class ServiceCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Locations extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Faqs extends Table {
  TextColumn get id => text()();
  TextColumn get question => text()();
  TextColumn get answer => text()();
  TextColumn get status => text().withDefault(const Constant('published'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Tracks the last successful full sync per entity name (matches
/// `SyncEntity.name` in sync_engine.dart) for "last updated" UI and to decide
/// whether a background resync is due.
class SyncMeta extends Table {
  TextColumn get entity => text()();
  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {entity};
}
