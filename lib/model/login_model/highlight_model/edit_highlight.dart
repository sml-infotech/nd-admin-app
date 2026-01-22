import 'package:nammadaiva_dashboard/model/login_model/highlight_model/highlight_create_model.dart';

class EditHighlightRequest {
  final String title;
  final String description;
  final List<HighLightTranslateModel>? translates;

  EditHighlightRequest({
    required this.title,
    required this.description,
    this.translates,
  });
  factory EditHighlightRequest.fromJson(Map<String, dynamic> json) {
    return EditHighlightRequest(
      title: json['title'] ?? "",
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
      'title': title,
      'description': description,
      'translations': translates
          ?.map((e) => {'language_code': e.languageCode,
            'title': e.title, 'description': e.description})
          .toList(),
    };
  }
}
