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
  final List<BlogTranslationDetails> translations;

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
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      image: json['image'] ?? '',
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      articleSections: (json['article_sections'] as List)
          .map((e) => ArticleSection.fromJson(e))
          .toList(),
      translations: (json['translations'] as List)
          .map((e) => BlogTranslationDetails.fromJson(e))
          .toList(),
    );
  }
}
class ArticleSection {
  final String id;
  final String title;
  final int position;
  final List<SectionParagraph> paragraphs;
  final List<SectionList> lists;

  ArticleSection({
    required this.id,
    required this.title,
    required this.position,
    required this.paragraphs,
    required this.lists,
  });

  factory ArticleSection.fromJson(Map<String, dynamic> json) {
    return ArticleSection(
      id: json['id'],
      title: json['title'],
      position: json['position'],
      paragraphs: (json['paragraphs'] as List)
          .map((e) => SectionParagraph.fromJson(e))
          .toList(),
      lists: (json['lists'] as List)
          .map((e) => SectionList.fromJson(e))
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
class SectionList {
  final String id;
  final String listType; // ordered | unordered
  final String heading;
  final int position;
  final List<ListPoint> points;

  SectionList({
    required this.id,
    required this.listType,
    required this.heading,
    required this.position,
    required this.points,
  });

  factory SectionList.fromJson(Map<String, dynamic> json) {
    return SectionList(
      id: json['id'],
      listType: json['list_type'],
      heading: json['heading'],
      position: json['position'],
      points: (json['points'] as List)
          .map((e) => ListPoint.fromJson(e))
          .toList(),
    );
  }
}
class ListPoint {
  final String id;
  final String point;
  final int position;

  ListPoint({
    required this.id,
    required this.point,
    required this.position,
  });

  factory ListPoint.fromJson(Map<String, dynamic> json) {
    return ListPoint(
      id: json['id'],
      point: json['point'],
      position: json['position'],
    );
  }
}
class BlogTranslationDetails {
  final String languageCode;
  final String name;
  final String description;
  final List<ArticleSection> articleSections;

  BlogTranslationDetails({
    required this.languageCode,
    required this.name,
    required this.description,
    required this.articleSections,
  });

  factory BlogTranslationDetails.fromJson(Map<String, dynamic> json) {
    return BlogTranslationDetails(
      languageCode: json['language_code'],
      name: json['name'],
      description: json['description'],
      articleSections: (json['article_sections'] as List)
          .map((e) => ArticleSection.fromJson(e))
          .toList(),
    );
  }
}
