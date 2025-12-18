import 'dart:convert';

class EventResponseModal {
  String id;
  String templeId;
  String name;
  String description;
  String location;
  String contactName;
  String contactPhone;
  DateTime startDate;
  DateTime endDate;
  String startTime;
  String endTime;
  List<String> images;
  bool isActive;
  String createdBy;
  DateTime createdAt;
  DateTime updatedAt;

  EventResponseModal({
    required this.id,
    required this.templeId,
    required this.name,
    required this.description,
    required this.location,
    required this.contactName,
    required this.contactPhone,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.images,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from JSON data
  factory EventResponseModal.fromJson(Map<String, dynamic> json) {
    return EventResponseModal(
      id: json['id'],
      templeId: json['temple_id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      images: List<String>.from(json['images']),
      isActive: json['is_active'],
      createdBy: json['created_by'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert the instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temple_id': templeId,
      'name': name,
      'description': description,
      'location': location,
      'contact_name': contactName,
      'contact_phone': contactPhone,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'start_time': startTime,
      'end_time': endTime,
      'images': images,
      'is_active': isActive,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class EventUpdateResponse {
  int code;
  String message;
  EventResponseModal data;

  EventUpdateResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  // Factory constructor to create an instance from JSON data
  factory EventUpdateResponse.fromJson(Map<String, dynamic> json) {
    return EventUpdateResponse(
      code: json['code'],
      message: json['message'],
      data: EventResponseModal.fromJson(json['data']),
    );
  }

  // Method to convert the instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}
