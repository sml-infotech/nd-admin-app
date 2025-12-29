class ActiveHighlightsResponse {
  final int code;
  final String message;
  final List<HighlightItem> data;

  ActiveHighlightsResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory ActiveHighlightsResponse.fromJson(Map<String, dynamic> json) {
    return ActiveHighlightsResponse(
      code: json['code'],
      message: json['message'],
      data: (json['data'] as List)
          .map((e) => HighlightItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
class HighlightItem {
  final String? id;
  final String? mediaType;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final int? position;
  final DateTime? uploadedAt;

  HighlightItem({
    this.id,
    this.mediaType,
    this.mediaUrl,
    this.thumbnailUrl,
    this.position,
    this.uploadedAt,
  });

  factory HighlightItem.fromJson(Map<String, dynamic> json) {
    return HighlightItem(
      id: json['id'] as String?,
      mediaType: json['media_type'] as String?,
      mediaUrl: json['media_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      position: json['position'] as int?,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'media_type': mediaType,
      'media_url': mediaUrl,
      'thumbnail_url': thumbnailUrl,
      'position': position,
      'uploaded_at': uploadedAt?.toIso8601String(),
    };
  }
}

