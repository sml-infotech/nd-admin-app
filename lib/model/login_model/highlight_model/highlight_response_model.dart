class HighlightResponse {
  final int code;
  final String message;
  final HighlightData data;

  HighlightResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory HighlightResponse.fromJson(Map<String, dynamic> json) {
    return HighlightResponse(
      code: json['code'],
      message: json['message'],
      data: HighlightData.fromJson(json['data']),
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
class HighlightData {
  final String id;
  final String mediaType;
  final String mediaUrl;
  final String thumbnailUrl;
  final int position;
  final bool isActive;
  final DateTime uploadedAt;
  final DateTime updatedAt;

  HighlightData({
    required this.id,
    required this.mediaType,
    required this.mediaUrl,
    required this.thumbnailUrl,
    required this.position,
    required this.isActive,
    required this.uploadedAt,
    required this.updatedAt,
  });

  factory HighlightData.fromJson(Map<String, dynamic> json) {
    return HighlightData(
      id: json['id'],
      mediaType: json['media_type'],
      mediaUrl: json['media_url'],
      thumbnailUrl: json['thumbnail_url'],
      position: json['position'],
      isActive: json['is_active'],
      uploadedAt: DateTime.parse(json['uploaded_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_type': mediaType,
      'media_url': mediaUrl,
      'thumbnail_url': thumbnailUrl,
      'position': position,
      'is_active': isActive,
      'uploaded_at': uploadedAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
