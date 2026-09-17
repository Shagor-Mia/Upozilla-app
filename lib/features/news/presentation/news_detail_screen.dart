import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/external_links.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/remote_image.dart';
import '../domain/news_article.dart';
import 'news_providers.dart';

class NewsDetailScreen extends ConsumerWidget {
  const NewsDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navNews)),
      body: AsyncValueWidget<NewsArticle>(
        value: ref.watch(newsArticleProvider(slug)),
        onRetry: () => ref.invalidate(newsArticleProvider(slug)),
        data: (article) => _ArticleBody(article: article),
      ),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final locale = Localizations.localeOf(context).toString();
    final published = article.publishedAt;
    final originalUrl = article.originalUrl;
    final text = article.body ?? article.summary;
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        if (article.image != null) RemoteImage(url: article.image, height: 220),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(article.title, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                [
                  if (article.category != null) article.category!,
                  if (published != null) Formatters.dateTime(published, locale: locale),
                ].join(' · '),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
              ),
              if (text != null) ...[
                const SizedBox(height: 16),
                Text(text, style: theme.textTheme.bodyLarge),
              ],
              if (originalUrl != null) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => ExternalLinks.openUrl(originalUrl),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.readOriginal),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
