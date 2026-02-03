class BlogResponse {
  final int code;
  final String message;
  final List<Blog> blogs;
  final int totalCount;
  final int page;
  final int limit;

  BlogResponse({
    required this.code,
    required this.message,
    required this.blogs,
    required this.totalCount,
    required this.page,
    required this.limit,
  });

  factory BlogResponse.fromJson(Map<String, dynamic> json) {
    return BlogResponse(
      code: json['code'],
      message: json['message'] ?? '',
      blogs:
          (json['blogs'] as List<dynamic>?)
              ?.map((e) => Blog.fromJson(e))
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
    'code': code,
    'message': message,
    'blogs': blogs.map((e) => e.toJson()).toList(),
    'totalCount': totalCount,
    'page': page,
    'limit': limit,
  };
}

class Blog {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String image;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Translation> translations;

  Blog({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map((e) => Translation.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug,
    'description': description,
    'image': image,
    'is_active': isActive,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'translations': translations.map((e) => e.toJson()).toList(),
  };
}

class Translation {
  final String languageCode;
  final String name;
  final String description;

  Translation({
    required this.languageCode,
    required this.name,
    required this.description,
  });

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      languageCode: json['language_code'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'language_code': languageCode,
    'name': name,
    'description': description,
  };
}
