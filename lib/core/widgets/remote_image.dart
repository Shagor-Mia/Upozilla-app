import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// All remote images go through cached_network_image (Section 8.3) with a
/// neutral placeholder for missing/broken URLs.
class RemoteImage extends StatelessWidget {
  const RemoteImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final placeholder = Container(
      width: width,
      height: height,
      color: scheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(Icons.image_outlined, color: scheme.outline),
    );

    final imageUrl = url;
    final Widget child = (imageUrl == null || imageUrl.isEmpty)
        ? placeholder
        : CachedNetworkImage(
            imageUrl: imageUrl,
            width: width,
            height: height,
            fit: fit,
            placeholder: (_, __) => placeholder,
            errorWidget: (_, __, ___) => placeholder,
          );

    if (borderRadius == null) return child;
    return ClipRRect(borderRadius: borderRadius!, child: child);
  }
}
