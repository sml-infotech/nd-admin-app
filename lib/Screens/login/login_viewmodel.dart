import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool isChecked = false;
  String message = '';

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void toggleCheckbox(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
  }

  void validateLogin() {
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
      message = "Login Successful";
    }

    notifyListeners(); // Important: notify the UI
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
