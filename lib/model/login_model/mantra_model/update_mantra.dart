class UpdateMantra {
  final String mantraId;
  final String mantraName;
  final String mantra;
  final String deityImageUrl;

  UpdateMantra({
    required this.mantraId,
    required this.mantraName,
    required this.mantra,
    required this.deityImageUrl,
  });

  factory UpdateMantra.fromJson(Map<String, dynamic> json) {
    return UpdateMantra(
      mantraId: json['mantra_id'] ?? "",
      mantraName: json['mantra_name'] ?? "",
      mantra: json['mantra'] ?? "",
      deityImageUrl: json['deity_image_url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mantra_id": mantraId,
      "mantra_name": mantraName,
      "mantra": mantra,
      "deity_image_url": deityImageUrl,
    };
  }
}
class MantraUpdateResponse {
  final int code;
  final String message;
  final UpdatedMantraData? data;

  MantraUpdateResponse({
    required this.code,
    required this.message,
    this.data,
  });

  factory MantraUpdateResponse.fromJson(Map<String, dynamic> json) {
    return MantraUpdateResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? "",
      data: json['data'] != null
          ? UpdatedMantraData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "code": code,
      "message": message,
      "data": data?.toJson(),
    };
  }
}

class UpdatedMantraData {
  final String id;
  final String mantraName;
  final String mantra;
  final String deityImageUrl;
  final String createdAt;
  final String updatedAt;

  UpdatedMantraData({
    required this.id,
    required this.mantraName,
    required this.mantra,
    required this.deityImageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UpdatedMantraData.fromJson(Map<String, dynamic> json) {
    return UpdatedMantraData(
      id: json['id'] ?? "",
      mantraName: json['mantra_name'] ?? "",
      mantra: json['mantra'] ?? "",
      deityImageUrl: json['deity_image_url'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "mantra_name": mantraName,
      "mantra": mantra,
      "deity_image_url": deityImageUrl,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
