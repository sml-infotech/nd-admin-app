
class CreateUsermodel {
  final String full_name;
  final String email;
  final String password;
  final String role;
  final String ?associated_temple_id;

  CreateUsermodel({
    required this.full_name,
    required this.email,
    required this.password,
    required this.role,
    this.associated_temple_id
  });

  factory CreateUsermodel.fromJson(Map<String, dynamic> json) {
    return CreateUsermodel(
      full_name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      associated_temple_id: json['associated_temple_id']??''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': full_name,
      'email': email,
      'password': password,
      'role': role,
      'associated_temple_id':associated_temple_id
    };
  }
}
