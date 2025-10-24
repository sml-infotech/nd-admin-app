

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpViewmodel extends ChangeNotifier{
  String otp = "";
  Timer? timer;
  bool _isLoading = false;

  String message = '';
  bool isOtpSuccess = false;
  var authService = AuthService();
 bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


Future<void> validOtp(String email) async {
    try {
      print("valid otp called");
      isLoading = true;
      notifyListeners();
      final response = await authService.verifyOtp(
          email, otp);
      if (response.message?.isNotEmpty == true) {
        print("->>> $response");
         final prefs = await SharedPreferences.getInstance();
         await prefs.setString('authToken', response.token!);
         await prefs.setString('userRole', response.user?.role??"");
        print("✅ Token saved: ${response.token}");
        message = response.message ?? "success";
        isOtpSuccess = true;
        print("message $message");
        isLoading = false;
         notifyListeners();
      } else {
        message = response.error ?? "some error occurred";
        isLoading = false;
        print("message $message");
      }
      notifyListeners();
    } catch (e) {
      message = "Something went wrong";
      isLoading = false;
      notifyListeners();
   
    }
  }


  Future<void> resendOtp(String email,String password) async {
    try {
      final response = await authService.loginUser(
          email, password);
      if (response.message?.isNotEmpty == true) {
        print("->>> $response");
        message = response.message ?? "success";
        notifyListeners();
      } else {
        message = response.error ?? "some error occurred";
        print("message $message");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
   
    }
  }
}