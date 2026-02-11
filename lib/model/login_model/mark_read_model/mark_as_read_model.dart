class MarkNotificationReadRequest {
  final List<String> notificationIds;

  MarkNotificationReadRequest({
    required this.notificationIds,
  });

  Map<String, dynamic> toJson() {
    return {
      "notification_ids": notificationIds,
    };
  }
}
