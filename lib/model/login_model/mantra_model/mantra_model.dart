class MantraModel {
  final String mantraName;
  final String mantra;
  final String deityImageUrl;
  final List<MantraTranslation> translations;


  MantraModel({
    required this.mantraName,
    required this.mantra,
    required this.deityImageUrl,
    required this.translations,
  });

  factory MantraModel.fromJson(Map<String, dynamic> json) {
    return MantraModel(
      mantraName: json['mantra_name'] ?? "",
      mantra: json['mantra'] ?? "",
      deityImageUrl: json['deity_image_url'] ?? "",
      translations: (json['translations'] as List<dynamic>? ?? [])
          .map((item) => MantraTranslation.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "mantra_name": mantraName,
      "mantra": mantra,
      "deity_image_url": deityImageUrl,
      "translations": translations.map((t) => t.toJson()).toList(),
    };
  }
}
class MantraTranslation {
  final String languageCode;
  final String mantraName;
  final String mantra;

  MantraTranslation({
    required this.languageCode,
    required this.mantraName,
    required this.mantra,
  });

  factory MantraTranslation.fromJson(Map<String, dynamic> json) {
    return MantraTranslation(
      languageCode: json['language_code'] ?? '',
      mantraName: json['mantra_name'] ?? '',
      mantra: json['mantra'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'mantra_name': mantraName,
      'mantra': mantra,
    };
  }
}
