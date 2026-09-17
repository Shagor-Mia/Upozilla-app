import 'package:dio/dio.dart' show CancelToken;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/faq_repository.dart';
import '../domain/faq.dart';

final faqsProvider = FutureProvider.autoDispose<List<Faq>>((ref) {
  final cancelToken = CancelToken();
  ref.onDispose(cancelToken.cancel);
  return ref.watch(faqRepositoryProvider).fetchFaqs(cancelToken: cancelToken);
});
