class CreateEventModal {
  final String? templeId; // required
  final String name; // required
  final String startDate; // required (YYYY-MM-DD)
  final String? description;
  final String? location;
  final String? contactName;
  final String? contactPhone;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final List<String>? images;
  final List<CreateEventTranslation> translations;
  CreateEventModal({
     this.templeId,
    required this.name,
    required this.startDate,
    this.description,
    this.location,
    this.contactName,
    this.contactPhone,
    this.endDate,
    this.startTime,
    this.endTime,
    this.images,
    required this.translations,
  });

  factory CreateEventModal.fromJson(Map<String, dynamic> json) {
    return CreateEventModal(
      templeId: json['temple_id'] ?? '',
      name: json['name'] ?? '',
      startDate: json['start_date'] ?? '',
      description: json['description'],
      location: json['location'],
      contactName: json['contact_name'],
      contactPhone: json['contact_phone'],
      endDate: json['end_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      translations: json['translations'],
    );
  }

  // 🔹 toJson method
  Map<String, dynamic> toJson() {
    return {
      "temple_id": templeId,
      "name": name,
      "start_date": startDate,
      if (description != null) "description": description,
      if (location != null) "location": location,
      if (contactName != null) "contact_name": contactName,
      if (contactPhone != null) "contact_phone": contactPhone,
      if (endDate != null) "end_date": endDate,
      if (startTime != null) "start_time": startTime,
      if (endTime != null) "end_time": endTime,
      if (images != null) "images": images,
      "translations": translations,
    };
  }
}

class CreateEventTranslation {
  final String languageCode;
  final String name;
  final String location;
  final String contactName;
  final String description;

  CreateEventTranslation({
    required this.languageCode,
    required this.name,
    required this.location,
    required this.description,
    required this.contactName,
  });
  factory CreateEventTranslation.fromJson(Map<String, dynamic> json) {
    return CreateEventTranslation(
      languageCode: json['language_code'] ?? '',
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
      contactName: json['contact_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'language_code': languageCode,
      'name': name,
      'location': location,
      'description': description,
      'contact_name': contactName,
    };
  }
}
