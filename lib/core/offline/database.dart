import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables.dart';

part 'database.g.dart';

/// Local offline-content store. Opened once in bootstrap and kept alive for
/// the app's lifetime.
@DriftDatabase(
  tables: [
    Places,
    Hospitals,
    Doctors,
    Markets,
    Businesses,
    Shops,
    ShopCategories,
    Representatives,
    NewsArticles,
    Services,
    ServiceCategories,
    Locations,
    Faqs,
    SyncMeta,
  ],
)
class OfflineDatabase extends _$OfflineDatabase {
  OfflineDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// In-memory instance for tests - avoids `drift_flutter`'s platform file
  /// path lookup, which needs a real Flutter app context.
  OfflineDatabase.forTesting() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 1;

  /// This database is a fully-replaceable read cache (see `SyncEngine`),
  /// never a source of truth - on any future version bump, drop and
  /// recreate every table instead of writing per-version column migrations.
  /// Without this, Drift's default behavior is to throw on open when
  /// `schemaVersion` increases, crashing existing installs before
  /// `SyncEngine` ever gets a chance to repopulate the cache.
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      for (final table in allTables) {
        await m.deleteTable(table.actualTableName);
      }
      await m.createAll();
    },
  );

  static QueryExecutor _openConnection() => driftDatabase(name: 'upazila_offline');
}

/// Overridden in bootstrap once the database is open.
final offlineDatabaseProvider = Provider<OfflineDatabase>((ref) {
  throw UnimplementedError('offlineDatabaseProvider must be overridden in bootstrap');
});
