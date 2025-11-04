  class EventListResponse {
  final int code;
  final String message;
  final int total;
  final int totalPages;
  final int currentPage;
  final List<EventItem> events;

  EventListResponse({
    required this.code,
    required this.message,
    required this.total,
    required this.totalPages,
    required this.currentPage,
    required this.events,
  });

  factory EventListResponse.fromJson(Map<String, dynamic> json) {
    return EventListResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      total: json['total'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => EventItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'total': total,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}

class EventItem {
  final String id;
  final String templeId;
  final String name;
  final String? description;
  final String? location;
  final String? contactName;
  final String? contactPhone;
  final String? startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final List<String>? images;
  final bool? isActive;
  final String? createdBy;
  final String? createdAt;
  final String? updatedAt;
  final String? createdByName;

  EventItem({
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
    this.createdByName,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
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
      createdByName: json['created_by_name'],
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
      if (createdByName != null) 'created_by_name': createdByName,
    };
  }
}
