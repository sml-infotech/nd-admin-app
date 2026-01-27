import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/fcm_post_model/fcm_request_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/logout/logout_request_model.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class DashboardViewmodel extends ChangeNotifier {
  UserService userService = UserService();

  Future<void> postFcmToken(String fcmToken, String device_type) async {
    try {
      var postRequest = FcmRequestModel(
        fcmToken: fcmToken,
        device_type: device_type,
      );
      var response = userService.postFcmToken(postRequest);
      print("FCM Token posted successfully");
    } catch (e) {
      print("Error posting FCM Token: $e");
    }
  }

  Future<void> logout(String fcmToken) async {
    try {
      var logoutRequest = LogoutRequestModel(fcmToken: fcmToken);

      final response = await userService.logout(logoutRequest);
      if (response.code == 201) {
        print("logoutted");
      } else {
        print("${response.message}");
      }
    } catch (e) {
      print(">>>>>>>>>>>>>${e}");
    }
  }
}
