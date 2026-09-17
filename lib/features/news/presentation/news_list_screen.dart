import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/offline/sync_engine.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/remote_image.dart';
import '../domain/news_article.dart';
import 'news_providers.dart';

class NewsListScreen extends ConsumerWidget {
  const NewsListScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    ref.read(newsRefreshTickProvider.notifier).state++;
    await ref.read(syncEngineProvider).syncAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navNews)),
      body: AsyncValueWidget<List<NewsArticle>>(
        value: ref.watch(newsListProvider),
        onRetry: () => _refresh(ref),
        data: (articles) => RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: articles.isEmpty
              ? ListView(children: const [SizedBox(height: 120), EmptyState()])
              : ListView.separated(
                  itemCount: articles.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) => NewsTile(article: articles[index]),
                ),
        ),
      ),
    );
  }
}

class NewsTile extends StatelessWidget {
  const NewsTile({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final published = article.publishedAt;
    final meta = [
      if (article.category != null) article.category!,
      if (published != null) Formatters.date(published, locale: locale),
    ].join(' · ');
    return ListTile(
      leading: RemoteImage(url: article.image, width: 72, height: 56, borderRadius: BorderRadius.circular(8)),
      title: Text(article.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: meta.isEmpty ? null : Text(meta),
      onTap: () => context.push(AppRoutes.newsArticle(article.slug)),
    );
  }
}
