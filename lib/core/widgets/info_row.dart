import 'package:flutter/material.dart';

/// Label/value row used across detail screens; hidden when the value is empty.
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.icon, required this.label, required this.value, this.onTap});

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = value;
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label, style: Theme.of(context).textTheme.labelMedium),
      subtitle: Text(text),
      onTap: onTap,
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
    );
  }
}
