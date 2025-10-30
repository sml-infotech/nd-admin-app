class AdminTempleUpdateResponse {
  final String? message;
  final TempleUpdateData? data;

  AdminTempleUpdateResponse({
    this.message,
    this.data,
  });

  factory AdminTempleUpdateResponse.fromJson(Map<String, dynamic> json) {
    return AdminTempleUpdateResponse(
      message: json['message'] as String?,
      data: json['data'] != null
          ? TempleUpdateData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class TempleUpdateData {
  final String? id;
  final String? name;
  final String? updatedBy;
  final String? role;

  TempleUpdateData({
    this.id,
    this.name,
    this.updatedBy,
    this.role,
  });

  factory TempleUpdateData.fromJson(Map<String, dynamic> json) {
    return TempleUpdateData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      updatedBy: json['updated_by'] as String?,
      role: json['role'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'updated_by': updatedBy,
      'role': role,
    };
  }
}
