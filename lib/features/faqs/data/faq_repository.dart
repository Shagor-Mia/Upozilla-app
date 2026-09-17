import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/offline/database.dart' as offline;
import '../domain/faq.dart';

/// Reads the offline-synced `faqs` table (Section: offline-first plan) -
/// `SyncEngine` keeps it fresh in the background.
class FaqRepository {
  FaqRepository({required offline.OfflineDatabase db}) : _db = db;

  final offline.OfflineDatabase _db;

  Future<List<Faq>> fetchFaqs({CancelToken? cancelToken}) async {
    final rows = await _db.select(_db.faqs).get();
    return rows.map((r) => Faq(id: r.id, question: r.question, answer: r.answer, status: r.status)).toList();
  }
}

final faqRepositoryProvider = Provider<FaqRepository>((ref) {
  return FaqRepository(db: ref.watch(offline.offlineDatabaseProvider));
});
