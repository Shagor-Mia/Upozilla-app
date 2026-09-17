import '../../../core/models/json_helpers.dart';

/// `ContractProgressEntryResponse`.
class ContractProgressEntry {
  const ContractProgressEntry({
    required this.id,
    required this.contractId,
    required this.note,
    this.createdByUserId,
    this.createdByName,
    this.percentComplete,
    this.images = const [],
    this.createdAt,
  });

  final String id;
  final String contractId;
  final String? createdByUserId;
  final String? createdByName;
  final String note;

  /// 0-100, optional.
  final int? percentComplete;
  final List<String> images;
  final DateTime? createdAt;

  factory ContractProgressEntry.fromJson(Map<String, dynamic> json) => ContractProgressEntry(
        id: json['id'] as String,
        contractId: json['contract_id'] as String? ?? '',
        createdByUserId: readString(json['created_by_user_id']),
        createdByName: readString(json['created_by_name']),
        note: json['note'] as String? ?? '',
        percentComplete: readInt(json['percent_complete']),
        images: readStringList(json['images']),
        createdAt: readDateTime(json['created_at']),
      );
}
