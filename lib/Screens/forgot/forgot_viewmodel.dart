
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart' show AuthService;

class ForgotViewmodel extends ChangeNotifier{

  TextEditingController emailController=TextEditingController();
  String message="";
  int? code ;
  var authService = AuthService();

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

Future<void> forgotPasswordApi() async {
    try {
      final response = await authService.forgotPassword(
          emailController.text,);
      if (response.code==200) {
        code=response.code;
        print("->>> $response");
        message = response.message ?? "success";
        notifyListeners();
      } 
      else if(response.code==401){
         message = response.message ?? "user not Found";
      
              notifyListeners();
      }
      else {
        message =  "some error occurred";
        print("message $message");
      }
      notifyListeners();
    } catch (e) {
      notifyListeners();
   
    }
  }



}