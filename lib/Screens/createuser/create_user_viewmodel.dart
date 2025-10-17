
import 'package:flutter/material.dart';
import 'package:nammadaiva_dashboard/service/auth_service.dart';

class CreateUserViewmodel  extends ChangeNotifier{
  bool isLoading = false;
  String message = '';
  bool isCreateUserSuccess = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController role = TextEditingController();
    var authService = AuthService();

 Future <void> validateUser() async {
  String email = emailController.text.trim();
    String password = passwordController.text.trim();
if (nameController.text.isEmpty) {
      message = "Please enter Name";
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
      else {
  await createUser();
    }
 }
bool isValidEmail(String email) {
  final regex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return regex.hasMatch(email);
}
  
Future<void> createUser() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await authService.createUser(nameController.text,emailController.text,passwordController.text,role.text);
      if (response.message?.isNotEmpty == true) {
        print("->>> $response");
        message = response.message ?? "success";
        print("message $message");
        isLoading = false;
        isCreateUserSuccess=true;
         notifyListeners();

      } else {
        message = "some error occurred";
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
Future <void> getTemples() async {
  final response = await authService.getTemples();
  response.data?.forEach((t) {
    print('Temple: ${t.name}, City: ${t.city}');
  });
}



}