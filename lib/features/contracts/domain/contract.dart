import '../../../core/models/json_helpers.dart';

/// `WorkContractResponse`. The backend stores `title`/`description` as
/// bn/en/ar triples and returns the locale-selected flat string (matches
/// `NewsArticle.title`, not raw `title_bn`); `employer_name`/`worker_name`
/// mirror the `market_id`/`market_name` flattening already used by
/// `Shop` rather than a nested party object.
class WorkContract {
  const WorkContract({
    required this.id,
    required this.title,
    required this.description,
    required this.paymentAmount,
    required this.paymentType,
    required this.currency,
    required this.status,
    this.employerUserId,
    this.employerName,
    this.workerUserId,
    this.workerName,
    this.startDate,
    this.endDate,
    this.employerAcceptedAt,
    this.workerAcceptedAt,
    this.employerCompletionConfirmedAt,
    this.workerCompletionConfirmedAt,
    this.cancelledByUserId,
    this.cancelledAt,
    this.cancellationReason,
    this.referenceImages = const [],
    this.createdAt,
  });

  final String id;

  /// Null once the employer account has been deleted (`ondelete=SET NULL`).
  final String? employerUserId;
  final String? employerName;

  /// Null once the worker account has been deleted, or briefly before a
  /// lookup resolves one on the create-contract screen.
  final String? workerUserId;
  final String? workerName;

  final String title;
  final String description;
  final double paymentAmount;

  /// `fixed` | `hourly` | `daily` | `milestone`
  final String paymentType;
  final String currency;
  final DateTime? startDate;
  final DateTime? endDate;

  /// `pending` | `active` | `rejected` | `cancelled` | `disputed` | `completed`
  final String status;

  final DateTime? employerAcceptedAt;
  final DateTime? workerAcceptedAt;
  final DateTime? employerCompletionConfirmedAt;
  final DateTime? workerCompletionConfirmedAt;
  final String? cancelledByUserId;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final List<String> referenceImages;
  final DateTime? createdAt;

  bool isEmployer(String? userId) => userId != null && userId == employerUserId;

  bool isWorker(String? userId) => userId != null && userId == workerUserId;

  /// The signed-in user's own completion confirmation, if any.
  bool hasConfirmedCompletion(String? userId) {
    if (isEmployer(userId)) return employerCompletionConfirmedAt != null;
    if (isWorker(userId)) return workerCompletionConfirmedAt != null;
    return false;
  }

  String? otherPartyName(String? currentUserId) => isEmployer(currentUserId) ? workerName : employerName;

  factory WorkContract.fromJson(Map<String, dynamic> json) => WorkContract(
        id: json['id'] as String,
        employerUserId: readString(json['employer_user_id']),
        employerName: readString(json['employer_name']),
        workerUserId: readString(json['worker_user_id']),
        workerName: readString(json['worker_name']),
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        paymentAmount: readDouble(json['payment_amount']) ?? 0,
        paymentType: json['payment_type'] as String? ?? 'fixed',
        currency: json['currency'] as String? ?? 'BDT',
        startDate: readDateTime(json['start_date']),
        endDate: readDateTime(json['end_date']),
        status: json['status'] as String? ?? 'pending',
        employerAcceptedAt: readDateTime(json['employer_accepted_at']),
        workerAcceptedAt: readDateTime(json['worker_accepted_at']),
        employerCompletionConfirmedAt: readDateTime(json['employer_completion_confirmed_at']),
        workerCompletionConfirmedAt: readDateTime(json['worker_completion_confirmed_at']),
        cancelledByUserId: readString(json['cancelled_by_user_id']),
        cancelledAt: readDateTime(json['cancelled_at']),
        cancellationReason: readString(json['cancellation_reason']),
        referenceImages: readStringList(json['reference_images']),
        createdAt: readDateTime(json['created_at']),
      );
}
