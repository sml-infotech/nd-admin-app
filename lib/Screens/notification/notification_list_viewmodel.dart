import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/notification_service.dart';

class NotificationListViewmodel extends ChangeNotifier {
  List<Notification> notifications = [];
  int page = 1;
  final int limit = 10;
  bool isLoading = true;
  bool hasMore = true;
  final NotificationService apiService = NotificationService();

  Future<void> fetchNotifications() async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.fetchNotifications(page);
      // if (response.data != null && response.data!.isNotEmpty) {
      //   notifications.addAll(response.data!);
      //   if (response.data!.length < limit) {
      //     hasMore = false;
      //   } else {
      //     page++;
      //   }
      // } else {
      //   hasMore = false;
      // }
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
