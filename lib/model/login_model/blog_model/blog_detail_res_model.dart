import 'package:nammadaiva_dashboard/model/login_model/blog_model/create_blog_model.dart';

class BlogDetailsResponse {
  final String message;
  final int code;
  final BlogDetails data;

  BlogDetailsResponse({
    required this.message,
    required this.code,
    required this.data,
  });

  factory BlogDetailsResponse.fromJson(Map<String, dynamic> json) {
    return BlogDetailsResponse(
      message: json['message'],
      code: json['code'],
      data: BlogDetails.fromJson(json['data']),
    );
  }
}

class BlogDetails {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String image;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ArticleSection> articleSections;
  final List<Translation> translations;

  BlogDetails({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.articleSections,
    required this.translations,
  });

  factory BlogDetails.fromJson(Map<String, dynamic> json) {
    return BlogDetails(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '', // <-- default empty
      image: json['image'] ?? '', // <-- default empty
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      articleSections: (json['article_sections'] as List? ?? [])
          .map((e) => ArticleSection.fromJson(e))
          .toList(),
      translations: (json['translations'] as List? ?? [])
          .map((e) => Translation.fromJson(e))
          .toList(),
    );
  }
}



class SectionParagraph {
  final String id;
  final String paragraph;
  final int position;

  SectionParagraph({
    required this.id,
    required this.paragraph,
    required this.position,
  });

  factory SectionParagraph.fromJson(Map<String, dynamic> json) {
    return SectionParagraph(
      id: json['id'],
      paragraph: json['paragraph'],
      position: json['position'],
    );
  }
}


class ListPoint {
  final String id;
  final String point;
  final int position;

  ListPoint({required this.id, required this.point, required this.position});

  factory ListPoint.fromJson(Map<String, dynamic> json) {
    return ListPoint(
      id: json['id'],
      point: json['point'],
      position: json['position'],
    );
  }
}


