import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  bool isChecked = false;
  bool isLoading = false;
  String message = '';
  bool isLoginSuccess = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var authService = AuthService();

  void toggleCheckbox(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  LoginViewModel() {
    emailController.addListener(() => notifyListeners());
    passwordController.addListener(() => notifyListeners());
  }

  bool validateLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    return email.isNotEmpty &&
        isValidEmail(email) &&
        password.isNotEmpty &&
        password.length > 6 &&
        isChecked;
  }

  Future<void> login() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await authService.loginUser(
        emailController.text.trim(),
        passwordController.text,
      );
      if (response.code == 200) {
        print("->>> $response");
        message = response.message ?? "success";
        isLoginSuccess = true;
        print("message $message");
        isLoading = false;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', response.token!);
        await prefs.setString('userRole', response.user?.role ?? "");
        await prefs.setString('UserName', response.user?.full_name ?? "");
        print("✅ Token saved: ${response.token}");

        notifyListeners();
      } else if (response.code == 401) {
        message = response.message ?? "Invalid email or password.";
        isLoading = false;
      } else {
        message = response.error ?? "some error occurred";
        isLoading = false;
        print("message $message");
      }
      notifyListeners();
    } catch (e) {
      message = "User not found.";
      isLoading = false;
      notifyListeners();
    }
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  void reset() {
    emailController.text = "";
    passwordController.text = "";
    isChecked = false;
    isLoading = false;
    message = '';
    isLoginSuccess = false;
  }
}
