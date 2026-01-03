class EditHighlightResponse {
  final int? code;
  final String? title;
  final String? description;
  final String? thumbnailUrl;
  final bool? isActive;
  final String? updatedAt;

  EditHighlightResponse({
    this.code,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.isActive,
    this.updatedAt,
  });

  factory EditHighlightResponse.fromJson(Map<String, dynamic> json) {
    return EditHighlightResponse(
      code: json['code'] ?? 0,
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      thumbnailUrl: json['thumbnail_url'] ?? "",
      isActive: json['is_active'] ?? false,
      updatedAt: json['updated_at'] ?? "",
    );
  }
}
