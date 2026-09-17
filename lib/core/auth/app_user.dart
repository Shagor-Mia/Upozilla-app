import '../models/json_helpers.dart';

/// `GET /auth/me` response (`UserResponse`).
class AppUser {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.role,
    required this.roles,
    required this.status,
    required this.phoneVerified,
    this.email,
    this.phone,
    this.oauthProvider,
    this.createdAt,
  });

  final String id;
  final String fullName;
  final String? email;
  final String? phone;
  final String role;
  final List<String> roles;
  final String status;
  final bool phoneVerified;
  final String? oauthProvider;
  final DateTime? createdAt;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        fullName: json['full_name'] as String? ?? '',
        email: readString(json['email']),
        phone: readString(json['phone']),
        role: json['role'] as String? ?? 'user',
        roles: readStringList(json['roles']),
        status: json['status'] as String? ?? 'active',
        phoneVerified: readBool(json['phone_verified']),
        oauthProvider: readString(json['oauth_provider']),
        createdAt: readDateTime(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'role': role,
        'roles': roles,
        'status': status,
        'phone_verified': phoneVerified,
        'oauth_provider': oauthProvider,
        'created_at': createdAt?.toIso8601String(),
      };

  AppUser copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? role,
    List<String>? roles,
    String? status,
    bool? phoneVerified,
  }) {
    return AppUser(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      roles: roles ?? this.roles,
      status: status ?? this.status,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      oauthProvider: oauthProvider,
      createdAt: createdAt,
    );
  }

  bool hasRole(String name) => role == name || roles.contains(name);
}
