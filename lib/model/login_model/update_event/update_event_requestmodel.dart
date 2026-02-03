import '../create_event/create_eventmodal.dart';

class EventUpdate {
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
  final List<CreateEventTranslation> translations;

  EventUpdate({
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
    required this.translations,
  });

  factory EventUpdate.fromJson(Map<String, dynamic> json) {
    return EventUpdate(
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
      translations: json['translations'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      "translations": translations,
    };
  }
}
