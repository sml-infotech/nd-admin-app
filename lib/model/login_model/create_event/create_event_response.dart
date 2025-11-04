class CreateEventResponse {
  final int code;
  final String message;
  final EventData data;

  CreateEventResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory CreateEventResponse.fromJson(Map<String, dynamic> json) {
    return CreateEventResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: EventData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class EventData {
  final String id;
  final String templeId;
  final String name;
  final String? description;
  final String? location;
  final String? contactName;
  final String? contactPhone;
  final String? startDate; // ISO8601 string
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final List<String>? images;
  final bool? isActive;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;

  EventData({
    required this.id,
    required this.templeId,
    required this.name,
    this.description,
    this.location,
    this.contactName,
    this.contactPhone,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.images,
    this.isActive,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'] ?? '',
      templeId: json['temple_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      location: json['location'],
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
      isActive: json['is_active'],
      createdBy: json['created_by'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'temple_id': templeId,
      'name': name,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (contactName != null) 'contact_name': contactName,
      if (contactPhone != null) 'contact_phone': contactPhone,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (images != null) 'images': images,
      if (isActive != null) 'is_active': isActive,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    };
  }
}
