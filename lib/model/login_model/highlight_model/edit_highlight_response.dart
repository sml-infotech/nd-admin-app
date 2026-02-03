import 'package:nammadaiva_dashboard/model/login_model/highlight_model/highlight_create_model.dart';

class EditHighlightResponse {
  final int? code;
  final String? title;
  final String? description;
  final String? thumbnailUrl;
  final bool? isActive;
  final String? updatedAt;
  final List<HighLightTranslateModel> translates;

  EditHighlightResponse({
    this.code,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.isActive,
    this.updatedAt,
    required this.translates,
  });

  factory EditHighlightResponse.fromJson(Map<String, dynamic> json) {
    return EditHighlightResponse(
      code: json['code'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      thumbnailUrl: json['thumbnail_url'] ?? "",
      isActive: json['is_active'] ?? false,
      updatedAt: json['updated_at'] ?? "",
      translates: json['translations'] != null
          ? (json['translations'] as List)
                .map(
                  (e) => HighLightTranslateModel(
                    languageCode: e['language_code'] ?? '',
                    title: e['title'] ?? '',
                    description: e['description'] ?? '',
                  ),
                )
                .toList()
          : [],
    );
  }
}
