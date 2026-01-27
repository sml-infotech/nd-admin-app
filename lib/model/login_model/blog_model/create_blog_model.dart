class BlogModel {
  String? name;
  String? description;
  String? image;
  bool? isActive;
  List<ArticleSection>? articleSections;
  List<Translation>? translations;

  BlogModel({
    this.name,
    this.description,
    this.image,
    this.isActive,
    this.articleSections,
    this.translations,
  });

  // This is the method your service is looking for
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "image": image,
      "is_active": isActive,
      // Map the lists to JSON lists
      "article_sections": articleSections?.map((x) => x.toJson()).toList(),
      "translations": translations?.map((x) => x.toJson()).toList(),
    };
  }
}

class ArticleSection {
  String? title;
  int? position;
  List<Paragraph>? paragraphs;
  List<SectionList>? lists;

  ArticleSection({this.title, this.position, this.paragraphs, this.lists});

  Map<String, dynamic> toJson() => {
    "title": title,
    "position": position,
    "paragraphs": paragraphs?.map((x) => x.toJson()).toList(),
    "lists": lists?.map((x) => x.toJson()).toList(),
  };
}

class Paragraph {
  String? text;
  int? position;

  Paragraph({this.text, this.position});

  Map<String, dynamic> toJson() => {"paragraph": text, "position": position};
}

class SectionList {
  String? listType;
  String? heading;
  int? position;
  List<Point>? points;

  SectionList({this.listType, this.heading, this.position, this.points});

  Map<String, dynamic> toJson() => {
    "list_type": listType,
    "heading": heading,
    "position": position,
    "points": points?.map((x) => x.toJson()).toList(),
  };
}

class Point {
  String? text;
  int? position;

  Point({this.text, this.position});

  Map<String, dynamic> toJson() => {"point": text, "position": position};
}

class Translation {
  String? languageCode;
  String? name;
  String? description;
  List<ArticleSection>? articleSections;

  Translation({
    this.languageCode,
    this.name,
    this.description,
    this.articleSections,
  });

  Map<String, dynamic> toJson() => {
    "language_code": languageCode,
    "name": name,
    "description": description,
    "article_sections": articleSections?.map((x) => x.toJson()).toList(),
  };
}
