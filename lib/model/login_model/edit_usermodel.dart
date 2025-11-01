
class EditUsermodel {
  final String id;
  final String fullName;
  final String role;
  final bool isActive;
  final List<String> associated_temple_ids;

  EditUsermodel({
    required this.id,
    required this.fullName,
    required this.role,
    required this.isActive,
    this.associated_temple_ids = const [],
  });

  factory EditUsermodel.fromJson(Map<String, dynamic> json) {
    return EditUsermodel(
      id: json["id"] ?? "",
      fullName: json["full_name"] ?? "",
      role: json["role"] ?? "",
      isActive: json["is_active"] ?? false,
      associated_temple_ids: (json["associated_temple_ids"] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "role": role,
        "is_active": isActive,
      };
}
