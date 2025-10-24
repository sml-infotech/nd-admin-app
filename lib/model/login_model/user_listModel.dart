import 'dart:convert';

class UserListResponse {
  final List<UserModel> users;
  final int totalCount;
  final int totalPages;
  final int currentPage;



  UserListResponse({required this.users,required this.totalCount,required this.totalPages,required this.currentPage});

  factory UserListResponse.fromJson(Map<String, dynamic> json) {
    return UserListResponse(
      users: (json['users'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e))
          .toList(),
          totalCount: json['totalCount'],
          totalPages:json['totalPages'],
          currentPage:json['currentPage']
    );
  }

  Map<String, dynamic> toJson() => {
        "users": users.map((e) => e.toJson()).toList(),
        "totalCount":totalCount,
        "totalPages":totalPages,
        "currentPage":currentPage
      };

  static UserListResponse fromJsonString(String str) =>
      UserListResponse.fromJson(json.decode(str));
}

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? associatedTempleId;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.associatedTempleId,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? "",
      fullName: json["full_name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      associatedTempleId: json["associated_temple_id"],
      isActive: json["is_active"] ?? false,
      createdAt: json["created_at"] != null
          ? DateTime.tryParse(json["created_at"])
          : null,
      updatedAt: json["updated_at"] != null
          ? DateTime.tryParse(json["updated_at"])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "role": role,
        "associated_temple_id": associatedTempleId,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

