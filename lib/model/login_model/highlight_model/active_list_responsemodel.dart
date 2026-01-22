import 'package:nammadaiva_dashboard/model/login_model/highlight_model/highlight_create_model.dart';

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
  final String? title;
  final String? description;
  final String? mediaType;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final int? position;
  final DateTime? uploadedAt;
  final List<HighLightTranslateModel>? translates;

  HighlightItem({
    this.id,
    this.title,
    this.description,
    this.mediaType,
    this.mediaUrl,
    this.thumbnailUrl,
    this.position,
    this.uploadedAt,
    this.translates,
  });

  factory HighlightItem.fromJson(Map<String, dynamic> json) {
    return HighlightItem(
      id: json['id'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      mediaType: json['media_type'] as String?,
      mediaUrl: json['media_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      position: json['position'] as int?,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.parse(json['uploaded_at'])
          : null,
      translates: json['translations'] != null
          ? (json['translations'] as List)
                .map(
                  (e) => HighLightTranslateModel(
                    title: e['title'] ?? '',
                    description: e['description'] ?? '',
                  ),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'media_type': mediaType,
      'media_url': mediaUrl,
      'thumbnail_url': thumbnailUrl,
      'position': position,
      'uploaded_at': uploadedAt?.toIso8601String(),
      'translations': translates
          ?.map((e) => {'title': e.title, 'description': e.description})
          .toList(),
    };
  }
}
