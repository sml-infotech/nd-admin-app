
import 'package:flutter/material.dart';

class ForgotViewmodel extends ChangeNotifier{

  TextEditingController emailController=TextEditingController();

 ForgotViewmodel() {
    emailController.addListener(() => notifyListeners());
 }

  bool validateEmail() {
    final email = emailController.text.trim();

    return email.isNotEmpty &&
        isValidEmail(email) ;
     }
     bool isValidEmail(String email) {
  final regex = RegExp(
      r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}
}