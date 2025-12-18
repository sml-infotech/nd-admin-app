class CreateTempleResponse {
  final int code;
  final String message;
  final TempleData data;

  CreateTempleResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CreateTempleResponse.fromJson(Map<String, dynamic> json) {
    return CreateTempleResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: TempleData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class TempleData {
  final String id;
  final String name;
  final String createdBy;
  final String role;

  TempleData({
    required this.id,
    required this.name,
    required this.createdBy,
    required this.role,
  });

  factory TempleData.fromJson(Map<String, dynamic> json) {
    return TempleData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      createdBy: json['created_by'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_by': createdBy,
      'role': role,
    };
  }
}
