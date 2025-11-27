class MarkReadResponse {
  final int code;
  final String message;
  final ContactData data;

  MarkReadResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  factory MarkReadResponse.fromJson(Map<String, dynamic> json) {
    return MarkReadResponse(
      code: json['code'],
      message: json['message'],
      data: ContactData.fromJson(json['data']),
    );
  }
}

class ContactData {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  ContactData({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.message,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      message: json['message'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
