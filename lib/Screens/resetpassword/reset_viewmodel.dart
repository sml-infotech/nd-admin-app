import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';
import 'package:nammadaiva_dashboard/service/password_service.dart';

class ResetViewmodel extends ChangeNotifier {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
bool isLoading=false;
  var authService = PasswordService();
  bool isChecked = false;
  String message="";
  bool isPasswordUpdated = false;

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


  Future<void> resetPassword() async {
    try {
      print("valid otp called");
      isLoading = true;
      notifyListeners();
      final response = await authService.resetPassword(
          confirmPassword.text,);
      if (response.code==200) {
        print("->>> $response");
   
        message = response.message ?? "success";
        print("message $message");
        isLoading = false;
      isPasswordUpdated=true;
         notifyListeners();
      }
      else if(response.code==400){
        isLoading = false;
        message = response.message ?? ".";
      }
      
       else {
        message ="some error occurred";
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


}
