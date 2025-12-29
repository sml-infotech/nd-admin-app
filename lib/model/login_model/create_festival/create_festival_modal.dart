import 'dart:convert';

class Festival {
  String name;
  String description;
  List<String> deityNames;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  List<Image> images;
  bool isActive;

  Festival({
    required this.name,
    required this.description,
    required this.deityNames,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.images,
    required this.isActive,
  });

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      name: json['name'],
      description: json['description'],
      deityNames: List<String>.from(json['deity_names']),
      startDate: json['start_date'],
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      images: List<Image>.from(json['images'].map((x) => Image.fromJson(x))),
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'deity_names': deityNames,
      'start_date': startDate,
      'end_date': endDate,
      'start_time': startTime,
      'end_time': endTime,
      'images': images.map((x) => x.toJson()).toList(),
      'is_active': isActive,
    };
  }
}

class Image {
  String url;
  bool isPrimary;

  Image({
    required this.url,
    required this.isPrimary,
  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      url: json['url'],
      isPrimary: json['is_primary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'is_primary': isPrimary,
    };
  }
}

class CreateFestivalResponse {
  int code;
  String message;
  Festival? festival;

  CreateFestivalResponse({
    required this.code,
    required this.message,
    this.festival,
  });

  factory CreateFestivalResponse.fromJson(Map<String, dynamic> json) {
    return CreateFestivalResponse(
      code: json['code']??0,
      message: json['message'],
      festival:
          json['festival'] != null ? Festival.fromJson(json['festival']) : null,
    );
  }
}