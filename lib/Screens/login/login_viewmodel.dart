import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';

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
    // Rebuild the button reactively whenever the user types
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
          emailController.text, passwordController.text);
      if (response.message?.isNotEmpty == true) {
        print("->>> $response");
        message = response.message ?? "success";
        isLoginSuccess = true;
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
      message = "User not found.";
      isLoading = false;
      notifyListeners();
   
    }
  }
bool isValidEmail(String email) {
  final regex = RegExp(
      r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
