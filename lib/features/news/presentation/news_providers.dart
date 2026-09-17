import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/news_repository.dart';
import '../domain/news_article.dart';

/// Triggers a manual `SyncEngine.syncAll()` on pull-to-refresh (see
/// `news_list_screen.dart`); the list itself reads the offline-synced table
/// reactively and updates on its own once new data lands.
final newsRefreshTickProvider = StateProvider<int>((ref) => 0);

final newsListProvider = StreamProvider.autoDispose<List<NewsArticle>>((ref) {
  return ref.watch(newsRepositoryProvider).watchArticles();
});

final newsArticleProvider = StreamProvider.autoDispose.family<NewsArticle, String>((ref, slug) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(newsRepositoryProvider).watchArticle(slug, cancelToken: cancelToken);
});
