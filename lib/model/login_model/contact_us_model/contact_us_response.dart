class ContactResponse {
  final int code;
  final String message;
  final List<ContactData> data;
  final int totalCount;
  final int unreadCount;
  final int page;
  final int limit;

  ContactResponse({
    required this.code,
    required this.message,
    required this.data,
    required this.totalCount,
    required this.unreadCount,
    required this.page,
    required this.limit,
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      code: json["code"],
      message: json["message"],
      data: (json["data"] as List)
          .map((e) => ContactData.fromJson(e))
          .toList(),
      totalCount: json["totalCount"],
      unreadCount: json["unreadCount"],
      page: json["page"],
      limit: json["limit"],
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
  final String createdAt;

  ContactData({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phone_number"],
      message: json["message"],
      isRead: json["is_read"],
      createdAt: json["created_at"],
    );
  }

  // Add copyWith method
  ContactData copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? message,
    bool? isRead,
    String? createdAt,
  }) {
    return ContactData(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      message: message ?? this.message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
