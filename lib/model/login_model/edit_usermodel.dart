
class EditUsermodel {
  final String id;
  final String fullName;
  final String role;
  final bool isActive;

  EditUsermodel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.isActive,
  });

  factory EditUsermodel.fromJson(Map<String, dynamic> json) {
    return EditUsermodel(
      id: json["id"] ?? "",
      fullName: json["full_name"] ?? "",
      role: json["role"] ?? "",
      isActive: json["is_active"] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "role": role,
        "is_active": isActive,
      };
}
