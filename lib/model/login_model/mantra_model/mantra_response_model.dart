class CreateMantraResponse {
  final int code;
  final String message;
  final MantraData data;

  CreateMantraResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CreateMantraResponse.fromJson(Map<String, dynamic> json) {
    return CreateMantraResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? "",
      data: MantraData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "data": data.toJson(),
    };
  }
}

class MantraData {
  final String id;
  final String mantraName;
  final String mantra;
  final String deityImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  MantraData({
    required this.id,
    required this.mantraName,
    required this.mantra,
    required this.deityImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MantraData.fromJson(Map<String, dynamic> json) {
    return MantraData(
      id: json['id'] ?? "",
      mantraName: json['mantra_name'] ?? "",
      mantra: json['mantra'] ?? "",
      deityImageUrl: json['deity_image_url'] ?? "",
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "mantra_name": mantraName,
      "mantra": mantra,
      "deity_image_url": deityImageUrl,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
