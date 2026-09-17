import '../../../core/models/json_helpers.dart';

/// `ContractPaymentResponse`.
class ContractPayment {
  const ContractPayment({
    required this.id,
    required this.contractId,
    required this.amount,
    required this.method,
    required this.status,
    this.loggedByUserId,
    this.loggedByName,
    this.note,
    this.proofImages = const [],
    this.paidAt,
    this.confirmedByUserId,
    this.confirmedByName,
    this.confirmedAt,
    this.createdAt,
  });

  final String id;
  final String contractId;
  final String? loggedByUserId;
  final String? loggedByName;
  final double amount;

  /// `cash` | `bkash` | `nagad` | `bank` | `other`
  final String method;
  final String? note;
  final List<String> proofImages;
  final DateTime? paidAt;

  /// `pending_confirmation` | `confirmed`
  final String status;
  final String? confirmedByUserId;
  final String? confirmedByName;
  final DateTime? confirmedAt;
  final DateTime? createdAt;

  bool get isConfirmed => status == 'confirmed';

  factory ContractPayment.fromJson(Map<String, dynamic> json) => ContractPayment(
        id: json['id'] as String,
        contractId: json['contract_id'] as String? ?? '',
        loggedByUserId: readString(json['logged_by_user_id']),
        loggedByName: readString(json['logged_by_name']),
        amount: readDouble(json['amount']) ?? 0,
        method: json['method'] as String? ?? 'cash',
        note: readString(json['note']),
        proofImages: readStringList(json['proof_images']),
        paidAt: readDateTime(json['paid_at']),
        status: json['status'] as String? ?? 'pending_confirmation',
        confirmedByUserId: readString(json['confirmed_by_user_id']),
        confirmedByName: readString(json['confirmed_by_name']),
        confirmedAt: readDateTime(json['confirmed_at']),
        createdAt: readDateTime(json['created_at']),
      );
}
