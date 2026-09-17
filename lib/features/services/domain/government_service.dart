import '../../../core/models/json_helpers.dart';

/// `ServiceResponse` — government / union service information (read-only).
class GovernmentService {
  const GovernmentService({
    required this.id,
    required this.locationId,
    required this.categoryId,
    required this.name,
    required this.status,
    this.description,
    this.eligibility,
    this.requiredDocuments = const [],
    this.fee,
    this.officialLink,
    this.officeName,
    this.officeContact,
  });

  final String id;
  final String locationId;
  final String categoryId;
  final String name;
  final String? description;
  final String? eligibility;
  final List<String> requiredDocuments;
  final double? fee;
  final String? officialLink;
  final String? officeName;
  final String? officeContact;
  final String status;

  factory GovernmentService.fromJson(Map<String, dynamic> json) => GovernmentService(
        id: json['id'] as String,
        locationId: json['location_id'] as String? ?? '',
        categoryId: json['category_id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        description: readString(json['description']),
        eligibility: readString(json['eligibility']),
        requiredDocuments: readStringList(json['required_documents']),
        fee: readDouble(json['fee']),
        officialLink: readString(json['official_link']),
        officeName: readString(json['office_name']),
        officeContact: readString(json['office_contact']),
        status: json['status'] as String? ?? 'published',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'location_id': locationId,
        'category_id': categoryId,
        'name': name,
        'description': description,
        'eligibility': eligibility,
        'required_documents': requiredDocuments,
        'fee': fee,
        'official_link': officialLink,
        'office_name': officeName,
        'office_contact': officeContact,
        'status': status,
      };
}

/// `ServiceCategoryResponse`
class ServiceCategory {
  const ServiceCategory({required this.id, required this.name, this.parentId});

  final String id;
  final String name;
  final String? parentId;

  factory ServiceCategory.fromJson(Map<String, dynamic> json) => ServiceCategory(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        parentId: readString(json['parent_id']),
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'parent_id': parentId};
}
