import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n.dart';
import '../../domain/representative.dart';

class RepresentativeTile extends StatelessWidget {
  const RepresentativeTile({super.key, required this.representative});

  final Representative representative;

  static String positionLabel(AppLocalizations l10n, String position) => switch (position) {
        'chairman' => l10n.positionChairman,
        'women_member' => l10n.positionWomenMember,
        'ward_member' => l10n.positionWardMember,
        _ => position,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person_outline)),
      title: Text(representative.fullName, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        [positionLabel(l10n, representative.position), if (representative.phone != null) representative.phone!]
            .join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
