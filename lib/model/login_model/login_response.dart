class LoginResponse {
  final int code;
  final String? message;
  final String? error;
  final String? token;
  final User? user;

  LoginResponse({
   required this.code,
    this.message,
    this.error,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'],
      message: json['message']?.toString(),
      error: json['error']?.toString(),
      token: json['token']?.toString(),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

class User {
  final String id;
  final String email;
  final String role;
  final String full_name;

  User({
    required this.id,
    required this.email,
    required this.role,
    required this.full_name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      role: json['role'],
      full_name: json['full_name'],
    );
  }
}