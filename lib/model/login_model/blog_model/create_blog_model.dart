class BlogModel {
  String? blogId;
  String name;
  String description;
  String image;
  bool isActive;
  List<ArticleSection> articleSections;
  List<Translation> translations;

  BlogModel({
    this.blogId,
    required this.name,
    required this.description,
    required this.image,
    required this.isActive,
    required this.articleSections,
    required this.translations,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      blogId: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      isActive: json['is_active'] ?? false,
      articleSections: (json['article_sections'] as List? ?? [])
          .map((e) => ArticleSection.fromJson(e))
          .toList(),
      translations: (json['translations'] as List? ?? [])
          .map((e) => Translation.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "blog_id": blogId,
      "name": name,
      "description": description,
      "image": image,
      "is_active": isActive,
      "article_sections": articleSections.map((e) => e.toJson()).toList(),
      "translations": translations.map((e) => e.toJson()).toList(),
    };
  }
}
class ArticleSection {
  String title;
  int position;
  List<Paragraph> paragraphs;
List<SectionList> lists;

  ArticleSection({
    required this.title,
    required this.position,
    required this.paragraphs,
    required this.lists,
  });

  factory ArticleSection.fromJson(Map<String, dynamic> json) {
    return ArticleSection(
      title: json['title'] ?? '',
      position: json['position'] ?? 1,
      paragraphs: (json['paragraphs'] as List? ?? [])
          .map((e) => Paragraph.fromJson(e))
          .toList(),
      lists: (json['lists'] as List? ?? [])
          .map((e) => SectionList.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "position": position,
        "paragraphs": paragraphs.map((e) => e.toJson()).toList(),
        "lists": lists.map((e) => e.toJson()).toList(),
      };
}
class Paragraph {
  String text;
  int position;

Paragraph({required this.text, required this.position});

  factory Paragraph.fromJson(Map<String, dynamic> json) {
    return Paragraph(
      text: json['paragraph'] ?? '',
      position: json['position'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() =>
      {"paragraph": text, "position": position};
}
class SectionList {
  String listType; // Numbered / Bulleted
  String heading;
  int position;
  List<Point> points;

  SectionList({
    required this.listType,
    required this.heading,
    required this.position,
    required this.points,
  });

  factory SectionList.fromJson(Map<String, dynamic> json) {
    return SectionList(
      listType: json['list_type'] ?? 'Numbered',
      heading: json['heading'] ?? '',
      position: json['position'] ?? 1,
      points: (json['points'] as List? ?? [])
          .map((e) => Point.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "list_type": listType,
        "heading": heading,
        "position": position,
        "points": points.map((e) => e.toJson()).toList(),
      };
}
class Point {
  String text;
  int position;

  Point({required this.text, required this.position});

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      text: json['point'] ?? '',
      position: json['position'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() =>
      {"point": text, "position": position};
}
class Translation {
  String languageCode;
  String name;
  String description;
  List<ArticleSection> articleSections;

  Translation({
    required this.languageCode,
    required this.name,
    required this.description,
    required this.articleSections,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      languageCode: json['language_code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      articleSections: (json['article_sections'] as List? ?? [])
          .map((e) => ArticleSection.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "language_code": languageCode,
        "name": name,
        "description": description,
        "article_sections":
            articleSections.map((e) => e.toJson()).toList(),
      };
}
