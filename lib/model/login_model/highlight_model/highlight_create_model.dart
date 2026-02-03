class HighlightCreateModel {
  final String? media_type;
  final String? media_url;
  final String? thumbnail_url;
  final String? title;
  final String? description;
  final List<HighLightTranslateModel>? translates;

  HighlightCreateModel({
    this.media_type,
    this.media_url,
    this.thumbnail_url,
    this.title,
    this.description,
    this.translates,
  });
  factory HighlightCreateModel.fromJson(Map<String, dynamic> json) {
    return HighlightCreateModel(
      media_type: json['media_type'] ?? '',
      media_url: json['media_url'] ?? '',
      thumbnail_url: json['thumbnail_url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
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
  Map<String, dynamic> toJson() {
    return {
      'media_type': media_type,
      'media_url': media_url,
      'thumbnail_url': thumbnail_url,
      'title': title,
      'description': description,
      'translations': translates
          ?.map(
            (e) => {
              'language_code': e.languageCode,
              'title': e.title,
              'description': e.description,
            },
          )
          .toList(),
    };
  }
}

class HighLightTranslateModel {
  final String? languageCode;
  final String? title;
  final String? description;

  HighLightTranslateModel({this.languageCode, this.title, this.description});

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'title': title,
      'description': description,
    };
  }
}
