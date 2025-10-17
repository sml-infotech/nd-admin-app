
class CreateUsermodel {
  final String full_name;
  final String email;
  final String password;
  final String role;

  CreateUsermodel({
    required this.full_name,
    required this.email,
    required this.password,
    required this.role,
  });

  factory CreateUsermodel.fromJson(Map<String, dynamic> json) {
    return CreateUsermodel(
      full_name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': full_name,
      'email': email,
      'password': password,
      'role': role,
    };
  }
}
