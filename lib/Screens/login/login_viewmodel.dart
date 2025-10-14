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

 Future <void> validateLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty) {
      message = "Please enter username";
    } 
    else if(!isValidEmail(email) ){
      message = "Please enter valid email";
    }
    else if (password.isEmpty) {
      message = "Please enter password";
    }
    else if (password.length < 6) {
      message = "Password must be at least 6 characters";
    }
     else if (!isChecked) {
      message = "Please accept terms and conditions";
    } else {
    await login();
    }

    notifyListeners();
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
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
