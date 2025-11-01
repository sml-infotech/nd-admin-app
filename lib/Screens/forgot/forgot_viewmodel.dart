
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart' show AuthService;
import 'package:nammadaiva_dashboard/service/password_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotViewmodel extends ChangeNotifier{

  TextEditingController emailController=TextEditingController();
  String message="";
  int? code ;
  bool isLoading=false;
   bool isVerifyLoading=false;
  var authService = AuthService();
  var passwordService=PasswordService();
  String otp = '';
  bool isOtpSuccess=false;

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
  isLoading=true;
  notifyListeners();
    try {
      final response = await passwordService.forgotPassword(
          emailController.text,);
      if (response.code==200) {
        code=response.code;
        print("->>> $response");
        message = response.message ?? "success";
        isLoading=false;
        notifyListeners();
      } 
      else if(response.code==401){
         message = response.message ?? "user not Found";
        isLoading=false;
        notifyListeners();
      }
      else {
        isLoading=false;
        notifyListeners();
        message =  "some error occurred";
        print("message $message");
      }
    } catch (e) {
      isLoading=false;
      notifyListeners();
   
    }
  }


  Future<void> validOtp(String email) async {
    try {
      print("valid otp called");
      isVerifyLoading = true;
      notifyListeners();
      final response = await authService.verifyOtp(
          email, otp);
      if (response.code==200) {
        print("->>> $response");
   final prefs = await SharedPreferences.getInstance();
         await prefs.setString('authToken', response.token!);
        print("✅ Token saved: ${response.token}");
        message = response.message ?? "success";
        isOtpSuccess = true;
        print("message $message");
        isVerifyLoading = false;
      
         notifyListeners();
      }
      else if(response.code==401){
        isVerifyLoading = false;
        message = response.message ?? "Invalid OTP.";


      }
      
       else {
        message = response.error ?? "some error occurred";
        isVerifyLoading = false;
        print("message $message");
      }
      notifyListeners();
    } catch (e) {
      message = "Something went wrong";
      isVerifyLoading = false;
      notifyListeners();
   
    }
  }


  void reset(){
    emailController.text="";
  }

}