import 'package:flutter/material.dart';

class ResetViewmodel extends ChangeNotifier {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool isChecked = false;

  ResetViewmodel() {
    password.addListener(notifyListeners);
    confirmPassword.addListener(notifyListeners);
  }

  bool validatePasswords() {
    final pwd = password.text.trim();
    final confirmPwd = confirmPassword.text.trim();

    return pwd.isNotEmpty &&
        pwd.length >= 6 && 
        confirmPwd.isNotEmpty &&
        pwd == confirmPwd; 
  }


}
