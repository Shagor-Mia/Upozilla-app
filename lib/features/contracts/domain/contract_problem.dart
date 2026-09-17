import '../../../core/models/json_helpers.dart';

/// `ContractProblemResponse` — doubles as the dispute record once escalated
/// (`status` carries `open → escalated → dispute_resolved`, mirroring the
/// backend's single-table lifecycle).
class ContractProblem {
  const ContractProblem({
    required this.id,
    required this.contractId,
    required this.category,
    required this.description,
    required this.status,
    this.raisedByUserId,
    this.raisedByName,
    this.images = const [],
    this.escalatedAt,
    this.resolution,
    this.resolutionNote,
    this.resolvedByUserId,
    this.resolvedByName,
    this.resolvedAt,
    this.createdAt,
  });

  final String id;
  final String contractId;
  final String? raisedByUserId;
  final String? raisedByName;

  /// `scope_disagreement` | `payment_issue` | `quality_issue` | `no_show` | `other`
  final String category;
  final String description;
  final List<String> images;

  /// `open` | `resolved` | `escalated` | `dispute_resolved`
  final String status;
  final DateTime? escalatedAt;

  /// `favor_employer` | `favor_worker` | `dismissed`; set only once an admin
  /// has ruled on the escalated dispute.
  final String? resolution;
  final String? resolutionNote;
  final String? resolvedByUserId;
  final String? resolvedByName;
  final DateTime? resolvedAt;
  final DateTime? createdAt;

  bool get isOpen => status == 'open';
  bool get isEscalated => status == 'escalated';

  factory ContractProblem.fromJson(Map<String, dynamic> json) => ContractProblem(
        id: json['id'] as String,
        contractId: json['contract_id'] as String? ?? '',
        raisedByUserId: readString(json['raised_by_user_id']),
        raisedByName: readString(json['raised_by_name']),
        category: json['category'] as String? ?? 'other',
        description: json['description'] as String? ?? '',
        images: readStringList(json['images']),
        status: json['status'] as String? ?? 'open',
        escalatedAt: readDateTime(json['escalated_at']),
        resolution: readString(json['resolution']),
        resolutionNote: readString(json['resolution_note']),
        resolvedByUserId: readString(json['resolved_by_user_id']),
        resolvedByName: readString(json['resolved_by_name']),
        resolvedAt: readDateTime(json['resolved_at']),
        createdAt: readDateTime(json['created_at']),
      );
}
