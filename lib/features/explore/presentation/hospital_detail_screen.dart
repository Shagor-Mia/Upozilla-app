import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/utils/external_links.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_widget.dart';
import '../../../core/widgets/info_row.dart';
import '../../../core/widgets/section_header.dart';
import '../domain/hospital.dart';
import 'explore_providers.dart';

class HospitalDetailScreen extends ConsumerWidget {
  const HospitalDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(hospitalDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(value.valueOrNull?.name ?? '')),
      body: AsyncValueWidget<Hospital>(
        value: value,
        onRetry: () => ref.invalidate(hospitalDetailProvider(id)),
        data: (hospital) => _HospitalBody(hospital: hospital),
      ),
    );
  }
}

class _HospitalBody extends ConsumerWidget {
  const _HospitalBody({required this.hospital});

  final Hospital hospital;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final doctors = ref.watch(hospitalDoctorsProvider(hospital.id));
    final contact = hospital.contact;
    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hospital.name, style: theme.textTheme.headlineSmall),
              const SizedBox(height: 8),
              Chip(label: Text(Formatters.humanize(hospital.type))),
              InfoRow(icon: Icons.place_outlined, label: l10n.address, value: hospital.address),
              InfoRow(
                icon: Icons.phone_outlined,
                label: l10n.contact,
                value: contact,
                onTap: contact == null ? null : () => ExternalLinks.dial(contact),
              ),
            ],
          ),
        ),
        SectionHeader(title: l10n.doctors),
        AsyncValueWidget<List<Doctor>>(
          value: doctors,
          onRetry: () => ref.invalidate(hospitalDoctorsProvider(hospital.id)),
          loading: const Padding(padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
          data: (items) => items.isEmpty
              ? Padding(padding: const EdgeInsets.all(16), child: Text(l10n.noDoctors))
              : Column(children: [for (final doctor in items) _DoctorTile(doctor: doctor)]),
        ),
      ],
    );
  }
}

class _DoctorTile extends StatelessWidget {
  const _DoctorTile({required this.doctor});

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final details = [
      if (doctor.specialty != null) doctor.specialty!,
      if (doctor.chamberDays.isNotEmpty) doctor.chamberDays.map(Formatters.humanize).join(', '),
      if (doctor.chamberHours != null) doctor.chamberHours!,
    ].join(' · ');
    final contact = doctor.contact;
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.medical_services_outlined)),
      title: Text(doctor.name),
      subtitle: details.isEmpty ? null : Text(details),
      trailing: contact == null
          ? null
          : IconButton(icon: const Icon(Icons.call_outlined), onPressed: () => ExternalLinks.dial(contact)),
    );
  }
}
