class UserResponse {
  final String ?message;
  final User? user;
  

  UserResponse({
    required this.message,
    required this.user,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      message: json['message'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user?.toJson(),
    };
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String role;
  final String? associatedTempleId;
  final String createdAt;
  final String otpCode;
  final String otpExpiry;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.associatedTempleId,
    required this.createdAt,
    required this.otpCode,
    required this.otpExpiry,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      associatedTempleId: json['associated_temple_id']??"",
      createdAt: json['created_at'] ?? '',
      otpCode: json['otp_code'] ?? '',
      otpExpiry: json['otp_expiry'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
      'associated_temple_id': associatedTempleId,
      'created_at': createdAt,
      'otp_code': otpCode,
      'otp_expiry': otpExpiry,
    };
  }
}
