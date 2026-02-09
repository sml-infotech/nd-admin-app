class NotificationModel {
  final bool success;
  final String message;
  final List<NotificationData> data;

  NotificationModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => NotificationData.fromJson(e))
          .toList(),
    );
  }
}

class NotificationData {
  final String id;
  final String title;
  final String body;
  final String notificationType;
  final bool isRead;
  final String createdAt;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.notificationType,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      notificationType: json['notification_type'] as String,
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'notification_type': notificationType,
      'is_read': isRead,
      'created_at': createdAt,
    };
  }
}
