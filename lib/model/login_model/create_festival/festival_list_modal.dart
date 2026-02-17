// Festival.dart

class FestivalResponse {
  final int code;
  final String message;
  final List<FestivalListModal> data;
  final Pagination pagination;

  FestivalResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory FestivalResponse.fromJson(Map<String, dynamic> json) {
    return FestivalResponse(
      code: json['code'],
      message: json['message'],
      data: List<FestivalListModal>.from(
        json['data'].map((x) => FestivalListModal.fromJson(x)),
      ),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class FestivalListModal {
  final String id;
  final String name;
  final String description;
  final List<String> deityNames;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startTime;
  final String? endTime;
  final List<ImageData> images;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CreateFestivalTranslation> translations;

  FestivalListModal({
    required this.id,
    required this.name,
    required this.description,
    required this.deityNames,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
    required this.translations,
  });

  factory FestivalListModal.fromJson(Map<String, dynamic> json) {
    return FestivalListModal(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      deityNames: List<String>.from(json['deity_names'].map((x) => x)),
      startDate: DateTime.parse(json['start_date']),
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'])
          : null,
      startTime: json['start_time'] ?? "",
      endTime: json['end_time'] ?? "",
      images: List<ImageData>.from(
        json['images'].map((x) => ImageData.fromJson(x)),
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      translations:
          (json['translations'] as List<dynamic>?)
              ?.map((e) => CreateFestivalTranslation.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ImageData {
  final String url;
  final bool isPrimary;

  ImageData({required this.url, required this.isPrimary});

  factory ImageData.fromJson(Map<String, dynamic> json) {
    return ImageData(url: json['url'], isPrimary: json['is_primary']);
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['total_pages'],
    );
  }
}

class CreateFestivalTranslation {
  final String languageCode;
  final String name;
  final String description;
  final List<String>? deities;

  CreateFestivalTranslation({
    required this.languageCode,
    required this.name,
    required this.description,
    this.deities,
  });

  factory CreateFestivalTranslation.fromJson(Map<String, dynamic> json) {
    return CreateFestivalTranslation(
      languageCode: json['language_code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      deities: json['deity_names'] != null
          ? List<String>.from(json['deity_names'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'name': name,
      'description': description,
      'deity_names': deities,
    };
  }
}
