import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/notification/notification_list.dart';
import 'package:nammadaiva_dashboard/service/notification_service.dart';

class NotificationListViewmodel extends ChangeNotifier {
  List<NotificationData> notifications = [];
  int page = 1;
  final int limit = 10;
  bool isLoading = true;
  bool hasMore = true;
  final NotificationService apiService = NotificationService();
  bool isInitialLoading = true;

  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      page = 1;
      notifications.clear();
      hasMore = true;
      isInitialLoading = true;
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.fetchNotifications(page);

      if (response.data != null && response.data!.isNotEmpty) {
        notifications.addAll(response.data!);
        page++;
        if (response.data!.length < limit) {
          hasMore = false;
        }
      } else {
        hasMore = false;
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading = false;
      isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      int index = notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        final response = await apiService.markAsRead(notificationId);
        notifications[index] = NotificationData(
          id: notifications[index].id,
          title: notifications[index].title,
          body: notifications[index].body,
          notificationType: notifications[index].notificationType,
          isRead: true,
          createdAt: notifications[index].createdAt,
        );
        notifyListeners();
      }
    } catch (e) {
      print("Error marking notification as read: $e");
    }
  }

  Future<void> reset() async {
    notifications.clear();
    page = 1;
    hasMore = true;
    isInitialLoading = true;
    isLoading = true;
    notifyListeners();
  }
}
