import 'package:nammadaiva_dashboard/model/login_model/notification/notification_list.dart';
import 'package:nammadaiva_dashboard/service/http_service.dart';
import 'package:nammadaiva_dashboard/service/url_constant.dart';

class NotificationService {
  final HttpApiService apiService = HttpApiService();

  Future<NotificationModel> fetchNotifications(int page) async {
    try {
      final url = '${UrlConstant.notificationList}?page=$page';
      print('Fetching notifications: $url');
      dynamic data = await apiService.get(url);
      return NotificationModel.fromJson(data);
    } catch (e) {
      print("Notification service decode fails: $e");
      throw Exception('API failed: $e');
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final url = '${UrlConstant.markNotificationRead}/$notificationId';
      print('Marking notification as read: $url');
      await apiService.post(url, {});
    } catch (e) {

    }

}
}
