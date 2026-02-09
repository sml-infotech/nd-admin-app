import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/model/login_model/fcm_post_model/fcm_request_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/logout/logout_request_model.dart';
import 'package:nammadaiva_dashboard/model/login_model/statictics_model/dashboard-statistics.dart';
import 'package:nammadaiva_dashboard/service/user_service.dart';

class DashboardViewmodel extends ChangeNotifier {
  UserService userService = UserService();
bool isLoading = true;
  DashboardStats? dashboardStats;

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
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout(String fcmToken) async {
    isLoading = true;
    notifyListeners();
    try {
      var logoutRequest = LogoutRequestModel(fcmToken: fcmToken);

      final response = await userService.logout(logoutRequest);
      if (response.code == 201) {
        isLoading = false;
        print("logoutted");
      } else {
        print("${response.message}");
        isLoading = false;
      }
    } catch (e) {
      isLoading = false;
      print(">>>>>>>>>>>>>${e}");
    }
  }

  Future<void> getDashboardData() async {
    try {
      isLoading = true;
      notifyListeners();
      var response = await userService.fetchDashBoardData();
      if (response.code == 200) {
        dashboardStats = response.data;
        isLoading = false;
        print("Dashboard data fetched successfully");
      } else {
        isLoading = false;

        print("Error fetching dashboard data: ${response.message}");
      }
    } catch (e) {
      isLoading = false;

      print("Error fetching dashboard data: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
