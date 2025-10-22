class EditUserResponse {
  final String message;
  final EditUser user;

  EditUserResponse({
    required this.message,
    required this.user,
  });

  factory EditUserResponse.fromJson(Map<String, dynamic> json) {
    return EditUserResponse(
      message: json['message'] as String,
      user: EditUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}

class EditUser {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final bool isActive;
  final String? associatedTempleId;
  final DateTime updatedAt;

  EditUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    required this.isActive,
    this.associatedTempleId,
    required this.updatedAt,
  });

  factory EditUser.fromJson(Map<String, dynamic> json) {
    return EditUser(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      isActive: json['is_active'] as bool,
      associatedTempleId: json['associated_temple_id'] as String?,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'is_active': isActive,
      'associated_temple_id': associatedTempleId,
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
