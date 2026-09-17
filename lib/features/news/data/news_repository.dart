import 'package:dio/dio.dart' show CancelToken;
import 'package:drift/drift.dart' show OrderingMode, OrderingTerm;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_paths.dart';
import '../../../core/offline/database.dart' as offline;
import '../domain/news_article.dart';

/// Reads the offline-synced `news_articles` table (Section: offline-first
/// plan) - `SyncEngine` fetches each article's full detail (not just the
/// summary) during sync, so browsing and reading are both fully offline.
class NewsRepository {
  NewsRepository({required ApiClient api, required offline.OfflineDatabase db})
      : _api = api,
        _db = db;

  final ApiClient _api;
  final offline.OfflineDatabase _db;

  Stream<List<NewsArticle>> watchArticles({String? category, CancelToken? cancelToken}) {
    final query = _db.select(_db.newsArticles);
    if (category != null) query.where((n) => n.category.equals(category));
    query.orderBy([(n) => OrderingTerm(expression: n.publishedAt, mode: OrderingMode.desc)]);
    return query.watch().map((rows) => rows.map(_toArticle).toList());
  }

  /// Reactive local read with a one-off network fallback if the article
  /// isn't synced yet (e.g. published after the last sync).
  Stream<NewsArticle> watchArticle(String slug, {CancelToken? cancelToken}) {
    final query = _db.select(_db.newsArticles)..where((n) => n.slug.equals(slug));
    return query.watchSingleOrNull().asyncMap((row) async {
      if (row != null) return _toArticle(row);
      final json = await _api.get(ApiPaths.newsArticle(slug), cancelToken: cancelToken);
      return NewsArticle.fromJson(asJsonObject(json));
    });
  }

  NewsArticle _toArticle(offline.NewsArticle row) => NewsArticle(
        id: row.id,
        sourceId: row.sourceId,
        locationId: row.locationId,
        category: row.category,
        title: row.title,
        slug: row.slug,
        summary: row.summary,
        image: row.image,
        publishedAt: row.publishedAt,
        status: row.status,
        body: row.body,
        originalUrl: row.originalUrl,
      );
}

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepository(api: ref.watch(apiClientProvider), db: ref.watch(offline.offlineDatabaseProvider));
});
