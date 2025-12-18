
class CreateUsermodel {
  final String full_name;
  final String email;
  final String password;
  final String role;
  final List <String> ?temple_ids;
  final String? phone_number;

  CreateUsermodel({
    required this.full_name,
    required this.email,
    required this.password,
    required this.role,
    this.temple_ids,
    this.phone_number,
  });

  factory CreateUsermodel.fromJson(Map<String, dynamic> json) {
    return CreateUsermodel(
      full_name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
      temple_ids:List<String>.from(json['temple_ids'] ?? []),
      phone_number: json['phone_number']??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': full_name,
      'email': email,
      'password': password,
      'role': role,
      'temple_ids':temple_ids,
      'phone_number':phone_number,
    };
  }
}
